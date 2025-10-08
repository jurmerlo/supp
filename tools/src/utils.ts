import Path from 'node:path';

export type LuaVersion = 'LuaJIT' | '5.1' | '5.2' | '5.3';

const __dirname = new URL('.', import.meta.url).pathname;

export const ROOT_DIR = Path.join(__dirname, '../');

export const VERSION = '0.1.0';
