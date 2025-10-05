import Path from 'node:path';

export type LuaVersion = 'LuaJIT' | '5.1' | '5.2' | '5.3';

const __dirname = new URL('.', import.meta.url).pathname;

export const rootDir = Path.join(__dirname, '../../');
