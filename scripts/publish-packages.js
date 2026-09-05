const { spawnSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const packages = [
  'android',
  'ios',
  'core',
  'cli',
  'electron'
];

console.log('Publishing packages to NPM...');

for (const pkg of packages) {
  const pkgPath = path.join(__dirname, '..', pkg, (pkg === 'android' || pkg === 'ios') ? '' : ''); // adjusted if they have nested package.json
  
  // Verify package.json exists
  if (!fs.existsSync(path.join(__dirname, '..', pkg, 'package.json'))) {
    console.log(`Skipping ${pkg} (no package.json found)`);
    continue;
  }

  console.log(`\n======================================`);
  console.log(`🚀 Publishing @jigra/${pkg}...`);
  console.log(`======================================`);

  const result = spawnSync('npm', ['publish', '--tag', 'latest-v2', '--access', 'public'], {
    cwd: path.join(__dirname, '..', pkg),
    stdio: 'inherit',
    shell: true
  });

  if (result.status !== 0) {
    console.error(`❌ Failed to publish ${pkg}. Please check the errors above.`);
    process.exit(1);
  }
  
  console.log(`✅ Successfully published @jigra/${pkg}`);
}

console.log('\n🎉 All packages published successfully!');
