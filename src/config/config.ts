import { existsSync, readFileSync } from 'node:fs';
import TOML from '@ltd/j-toml';
import type { LuaVersion } from '../utils.js';
import type { AtlasConfig } from './atlasConfig.js';
import type { TilesetConfig } from './tilesetConfig.js';

export type Config = {
  assetsDir?: string;
  sourceDir?: string;
  outDir?: string;
  minify?: boolean;
  bundle?: boolean;
  luaVersion?: LuaVersion;
  atlases?: AtlasConfig[];
  tilesets?: TilesetConfig[];
};

export function readConfig(): Config | undefined {
  if (!existsSync('supp.toml')) {
    process.stdout.write('Error: No supp.toml file found.\n');
    return;
  }

  const configData = readFileSync('supp.toml', 'utf-8');
  try {
    const config: Config = TOML.parse(configData, {
      bigint: false,
    });
    return config;
  } catch (error) {
    process.stdout.write(`Error: Failed to parse supp.toml: ${(error as Error).message}\n`);
    return;
  }
}
