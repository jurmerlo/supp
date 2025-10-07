import { existsSync, readFileSync } from 'node:fs';
import TOML from '@ltd/j-toml';
export function readConfig() {
    if (!existsSync('supp.toml')) {
        process.stdout.write('Error: No supp.toml file found.\n');
        return;
    }
    const configData = readFileSync('supp.toml', 'utf-8');
    try {
        const config = TOML.parse(configData, {
            bigint: false,
        });
        return config;
    }
    catch (error) {
        process.stdout.write(`Error: Failed to parse supp.toml: ${error.message}\n`);
        return;
    }
}
