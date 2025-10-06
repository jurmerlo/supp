import Path from 'node:path';
import { Command } from 'commander';
import pkg from '../package.json' with { type: 'json' };
import { packAtlas } from './atlas/index.js';
import { buildAndRun, buildProject, createLoveFile } from './build/build.js';
import { bundleSupp } from './build/bundleSupp.js';
import { readConfig } from './config/config.js';
import { type LuaVersion, rootDir } from './utils.js';

type BundleOptions = {
  out?: string;
  exclude?: string[];
  luaVersion?: LuaVersion;
};

function bundle({ out, exclude = [], luaVersion = 'LuaJIT' }: BundleOptions) {
  const outPath = out ? Path.join(process.cwd(), out) : process.cwd();
  bundleSupp(rootDir, outPath, exclude, luaVersion);
}

type BuildOptions = {
  project?: string;
  noAtlas?: boolean;
  clean?: boolean;
};

function build({ noAtlas, clean, project }: BuildOptions) {
  if (project) {
    const projectPath = Path.isAbsolute(project) ? project : Path.join(process.cwd(), project);
    process.chdir(projectPath);
  }
  const config = readConfig();
  if (!config) {
    process.stdout.write('Error: No valid configuration found. Aborting build.\n');
    return;
  }
  buildProject(config, noAtlas, clean);
}

function run({ noAtlas, clean, project }: BuildOptions) {
  if (project) {
    const projectPath = Path.isAbsolute(project) ? project : Path.join(process.cwd(), project);
    process.chdir(projectPath);
  }
  const config = readConfig();
  if (!config) {
    process.stdout.write('Error: No valid configuration found. Aborting run.\n');
    return;
  }
  buildAndRun(config, noAtlas, clean);
}

function atlas({ project }: { project?: string }) {
  if (project) {
    const projectPath = Path.isAbsolute(project) ? project : Path.join(process.cwd(), project);
    process.chdir(projectPath);
  }
  const config = readConfig();
  if (!config) {
    process.stdout.write('Error: No valid configuration found. Aborting packing.\n');
    return;
  }
  packAtlas(config);
}

const program = new Command();
program.name('Supp').description('Supp CLI').version(pkg.version);
const lib = program.command('lib').description('Supp library commands.');

lib
  .command('bundle')
  .description('Bundle the Supp library files.')
  .option('-e, --exclude [libraries...]', 'Specify the libraries you want to exclude from the bundle.')
  .option('-o, --out <string>', 'The path to save the bundle to relative to the current directory.')
  .option('-l, --luaVersion <string>', 'The Lua version to target. One of LuaJIT, 5.1, 5.2, 5.3.')
  .action(bundle);

program
  .command('build')
  .description('Build the Supp project.')
  .option('-c, --clean', 'Clean the export directory.')
  .option('--noAtlas', "Don't build the sprite atlas.")
  .option('-p, --project <string>', 'The root folder of the project.')
  .action(build);

program
  .command('run')
  .description('Build and run the Supp project.')
  .option('-c, --clean', 'Clean the export directory.')
  .option('--noAtlas', "Don't build the sprite atlas.")
  .action(run);

program
  .command('.love')
  .description('Create a .love file from a folder.')
  .option('-n, --name <string>', 'The name of the .love file.')
  .option('-p, --project <string>', 'The input folder. Defaults to export.')
  .action(createLoveFile);

program
  .command('atlas')
  .description('Pack images into a sprite atlas.')
  .option('-p, --project <string>')
  .action((options) => {
    atlas(options);
  });

program.parse();
