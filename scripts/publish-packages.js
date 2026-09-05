const fs = require('fs');
const path = require('path');
const readline = require('readline');
const { execSync, spawnSync } = require('child_process');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const ask = (query) => new Promise(resolve => rl.question(query, resolve));

const packages = ['android', 'ios', 'core', 'cli', 'electron'];

function parseVersion(v) {
  const parts = v.split('.').map(Number);
  return { major: parts[0], minor: parts[1], patch: parts[2] };
}

function stringifyVersion(v) {
  return `${v.major}.${v.minor}.${v.patch}`;
}

async function main() {
  // Read current version
  const lernaPath = path.join(__dirname, '..', 'lerna.json');
  const lernaConfig = JSON.parse(fs.readFileSync(lernaPath, 'utf8'));
  const currentVersion = lernaConfig.version;
  const parsed = parseVersion(currentVersion);

  const patchVersion = stringifyVersion({ major: parsed.major, minor: parsed.minor, patch: parsed.patch + 1 });
  const minorVersion = stringifyVersion({ major: parsed.major, minor: parsed.minor + 1, patch: 0 });
  const majorVersion = stringifyVersion({ major: parsed.major + 1, minor: 0, patch: 0 });

  console.log(`Current version: ${currentVersion}`);
  console.log(`Select a new version:`);
  console.log(`1) Patch (${patchVersion})`);
  console.log(`2) Minor (${minorVersion})`);
  console.log(`3) Major (${majorVersion})`);
  console.log(`4) Custom`);

  const choice = await ask('> ');

  let newVersion = '';
  if (choice === '1') newVersion = patchVersion;
  else if (choice === '2') newVersion = minorVersion;
  else if (choice === '3') newVersion = majorVersion;
  else if (choice === '4') {
    newVersion = await ask('Enter custom version (e.g., 2.4.1-beta.0): ');
  } else {
    console.log('Invalid choice. Exiting.');
    process.exit(1);
  }

  const confirm = await ask(`\nPreview: The version will be bumped from ${currentVersion} to ${newVersion}. Proceed? (y/n): `);
  if (confirm.toLowerCase() !== 'y') {
    console.log('Aborted.');
    process.exit(0);
  }

  console.log(`\n======================================`);
  console.log(`🔄 Updating package versions...`);
  console.log(`======================================`);

  // Update lerna.json
  lernaConfig.version = newVersion;
  fs.writeFileSync(lernaPath, JSON.stringify(lernaConfig, null, 2) + '\n');
  console.log('Updated lerna.json');

  // Update root package.json (if it has a version)
  const rootPkgPath = path.join(__dirname, '..', 'package.json');
  const rootPkg = JSON.parse(fs.readFileSync(rootPkgPath, 'utf8'));
  if (rootPkg.version) rootPkg.version = newVersion;
  fs.writeFileSync(rootPkgPath, JSON.stringify(rootPkg, null, 2) + '\n');
  console.log('Updated package.json (root)');

  // Update workspace packages
  for (const pkg of packages) {
    const pkgPath = path.join(__dirname, '..', pkg, 'package.json');
    if (!fs.existsSync(pkgPath)) continue;

    const pkgData = JSON.parse(fs.readFileSync(pkgPath, 'utf8'));
    pkgData.version = newVersion;

    // Update internal dependencies
    const deps = ['dependencies', 'devDependencies', 'peerDependencies'];
    for (const depType of deps) {
      if (pkgData[depType]) {
        for (const depName of Object.keys(pkgData[depType])) {
          if (depName.startsWith('@jigra/')) {
            pkgData[depType][depName] = `^${newVersion}`;
          }
        }
      }
    }

    fs.writeFileSync(pkgPath, JSON.stringify(pkgData, null, 2) + '\n');
    console.log(`Updated ${pkg}/package.json`);
  }

  console.log(`\n======================================`);
  console.log(`🔨 Building packages...`);
  console.log(`======================================`);
  
  // Try skipping native build step in prerelease.sh
  try {
    execSync('bash scripts/prerelease.sh', { stdio: 'inherit', cwd: path.join(__dirname, '..') });
    execSync('npx lerna run build', { stdio: 'inherit', cwd: path.join(__dirname, '..') });
  } catch (err) {
    console.error('Build failed!', err);
    process.exit(1);
  }

  console.log(`\n======================================`);
  console.log(`🚀 Publishing packages...`);
  console.log(`======================================`);

  for (const pkg of packages) {
    if (!fs.existsSync(path.join(__dirname, '..', pkg, 'package.json'))) continue;
    
    console.log(`\n--> Publishing @jigra/${pkg}...`);
    const result = spawnSync('npm', ['publish', '--tag', 'latest-v2', '--access', 'public'], {
      cwd: path.join(__dirname, '..', pkg),
      stdio: 'inherit',
      shell: true
    });

    if (result.status !== 0) {
      console.error(`❌ Failed to publish ${pkg}. Stop publishing.`);
      process.exit(1);
    }
  }

  console.log(`\n======================================`);
  console.log(`📦 Committing and Pushing to GitHub...`);
  console.log(`======================================`);
  try {
    const cwd = path.join(__dirname, '..');
    execSync('git add lerna.json package.json android/package.json ios/package.json core/package.json cli/package.json electron/package.json', { cwd, stdio: 'inherit' });
    execSync(`git commit -m "Release v${newVersion}"`, { cwd, stdio: 'inherit' });
    execSync(`git tag ${newVersion} -m ${newVersion}`, { cwd, stdio: 'inherit' });
    execSync('git push --follow-tags origin 2.x', { cwd, stdio: 'inherit' });
    console.log('✅ Successfully pushed to GitHub!');
  } catch (err) {
    console.error('❌ Failed to commit or push to GitHub.', err);
  }

  console.log(`\n🎉 All done! Jigra v${newVersion} is published and pushed!`);
  rl.close();
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
