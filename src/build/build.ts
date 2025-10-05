import { spawn } from 'node:child_process';
import { cpSync, createWriteStream, existsSync, mkdirSync, writeFileSync } from 'node:fs';
import Path from 'node:path';
import archiver from 'archiver';
import { bundle } from 'luabundle';
import luamin from 'luamin';
import { rimrafSync } from 'rimraf';
import { packAtlas } from '../atlas/index.js';
import type { Config } from '../config/config.js';

type PackLoveOptions = {
  name?: string;
  project?: string;
};

export function createLoveFile({ name, project }: PackLoveOptions) {
  let destination = name ? name : 'game';
  if (!destination.endsWith('.love')) {
    destination += '.love';
  }

  const outPath = Path.join(process.cwd(), destination);
  const output = createWriteStream(outPath);

  const source = project ? project : 'export';

  const archive = archiver('zip');
  archive.pipe(output);

  archive.directory(source, false);
  archive.finalize();
}

export function buildProject(config: Config, noAtlas = false, clean = false) {
  if (!noAtlas) {
    packAtlas(config);
  }

  const outDir = Path.join(process.cwd(), config.outDir || 'export');
  if (clean) {
    rimrafSync(outDir);
  }

  const assetsDir = Path.join(process.cwd(), config.assetsDir || 'assets');

  if (!existsSync(assetsDir)) {
    mkdirSync(assetsDir);
  }

  if (!existsSync(outDir)) {
    mkdirSync(outDir);
  }

  const sourceDir = Path.join(process.cwd(), config.sourceDir || 'src');
  if (config.bundle) {
    const mainPath = Path.join(sourceDir, 'main.lua');
    let luaBundle = bundle(mainPath, {
      luaVersion: config.luaVersion || 'LuaJIT',
      paths: [Path.join(sourceDir, '?.lua')],
    });

    if (config.minify) {
      luaBundle = luamin.minify(luaBundle);
    }
    writeFileSync(Path.join(outDir, 'main.lua'), luaBundle);
  } else {
    cpSync(sourceDir, outDir, { recursive: true });
  }

  process.stdout.write(`Build complete! Output in ${outDir}\n`);
}

export function buildAndRun(config: Config, noAtlas = false, clean = false) {
  buildProject(config, noAtlas, clean);

  const cmd = spawn('love', [Path.join(process.cwd(), config.outDir || 'export')]);

  cmd.stdout.on('data', (data) => {
    process.stdout.write(data);
  });

  cmd.stderr.on('data', (data) => {
    process.stderr.write(data);
  });

  cmd.on('close', (code) => {
    process.stdout.write(`love run exited with code ${code}\n`);
  });
}
