declare module "fs" {
  export const readFileSync: any;
  export const writeFileSync: any;
  export const existsSync: any;
  export const readdirSync: any;
  export const statSync: any;
  export const copyFileSync: any;
  export const unlinkSync: any;
  export const renameSync: any;
  export const mkdirSync: any;
  export const rmdirSync: any;
  export const realpathSync: any;
  export const readFile: any;
  export const writeFile: any;
  export const access: any;
  export const accessSync: any;
  export const constants: any;
  export const mkdir: any;
  export const symlink: any;
  export const readdir: any;
  export const stat: any;
  export const lstat: any;
  export const rename: any;
}
declare module "path" {
  export const join: any;
  export const resolve: any;
  export const basename: any;
  export const dirname: any;
  export const relative: any;
  export const extname: any;
  export const parse: any;
  export const sep: any;
}
declare module "child_process" {
  export const exec: any;
  export const execSync: any;
  export const spawn: any;
}
declare module "os" {
  export const platform: any;
  export const release: any;
  export const type: any;
  export const homedir: any;
}
declare module "crypto";
declare module "util" {
  export const promisify: any;
}
declare module "events";
declare module "assert";
declare namespace NodeJS {
  export interface Process {
    platform: string;
    stdin: any;
    stdout: any;
    stderr: any;
    env: any;
    argv: any;
    cwd(): string;
    exit(code?: number): never;
    on(event: string, callback: any): void;
    hrtime(time?: any): any;
  }
}
declare var process: NodeJS.Process;
declare module "timers" {
  export const setTimeout: any;
}
declare var require: any;
declare var console: any;
declare var __dirname: string;
declare var Buffer: any;
