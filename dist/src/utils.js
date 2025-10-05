import Path from 'node:path';
const __dirname = new URL('.', import.meta.url).pathname;
export const rootDir = Path.join(__dirname, '../../');
