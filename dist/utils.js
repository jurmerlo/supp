import Path from 'node:path';
const __dirname = new URL('.', import.meta.url).pathname;
export const ROOT_DIR = Path.join(__dirname, '../');
export const VERSION = '0.1.0';
