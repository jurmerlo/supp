import { existsSync, mkdirSync, readdirSync, readFileSync, writeFileSync } from 'node:fs';
import Path from 'node:path';
import { bundleString } from 'luabundle';
import { VERSION } from '../utils.js';
const requireRegex = /require\(['"](.*)['"]\)/g;
export function bundleSupp(rootDir, outPath, exclude, luaVersion) {
    const modules = getModules(rootDir, exclude);
    const dict = createDict(rootDir, modules);
    const importFile = buildImportFile(dict);
    let ioBundle = bundleString(importFile, {
        paths: [Path.join(rootDir, '?.lua')],
        luaVersion,
    });
    // Add the correct type to the output.
    const requireWithTypes = `
local bundle = __bundle_require("__root")
---@cast bundle supp.Supp

return bundle`;
    const version = `-- Supp version: ${VERSION}\n-- luacheck: ignore\n-- cSpell:ignore luabundle supp\n`;
    ioBundle = version + ioBundle.replace('return __bundle_require("__root")', requireWithTypes);
    if (!existsSync(outPath)) {
        mkdirSync(outPath, { recursive: true });
    }
    writeFileSync(Path.join(outPath, 'supp.lua'), ioBundle);
}
function getModules(rootDir, exclude = []) {
    const modules = [];
    const suppDir = Path.join(rootDir, 'supp');
    const paths = readdirSync(suppDir, { recursive: true, withFileTypes: true });
    for (const dirent of paths) {
        if (dirent.isDirectory()) {
            continue;
        }
        const fileName = dirent.name.replace('.lua', '');
        const dir = dirent.parentPath.replace(rootDir, '');
        const fullPath = Path.join(dir, fileName);
        for (const ex of exclude) {
            if (fullPath.includes(ex)) {
                break;
            }
        }
        const module = fullPath.replaceAll('/', '.');
        modules.push(module);
    }
    return modules;
}
function createDict(rootDir, modules) {
    const dict = {};
    while (modules.length > 0) {
        const module = modules.pop();
        if (!module) {
            break;
        }
        // Find requires in the module and add them to the list.
        const filePath = Path.join(rootDir, `${module.replace(/\./g, '/')}.lua`);
        const content = readFileSync(filePath, 'utf-8');
        const matches = content.matchAll(requireRegex);
        for (const match of matches) {
            const requiredModule = match[1];
            if (!modules.includes(requiredModule)) {
                modules.push(requiredModule);
            }
        }
        const index = module.lastIndexOf('.');
        if (index === -1) {
            continue;
        }
        const key = module.slice(0, index);
        let name = module.slice(index + 1);
        name = name[0].toUpperCase() + name.slice(1);
        if (!dict[key]) {
            dict[key] = [];
        }
        if (!dict[key].includes(name)) {
            dict[key].push(name);
        }
    }
    return dict;
}
function buildImportFile(dict) {
    let content = '';
    // Add all the required modules and types.
    for (const key in dict) {
        content += `---${key} files\n`;
        // Add the require lines.
        for (const name of dict[key]) {
            const lowercaseName = name[0].toLowerCase() + name.slice(1);
            content += `local ${name} = require('${key}.${lowercaseName}')\n`;
        }
        content += '\n';
        if (key === 'supp') {
            continue;
        }
        // Add the types.
        content += `---@class ${key}\n`;
        for (const name of dict[key]) {
            content += `---@field ${name} ${key}.${name}\n`;
        }
        content += '\n';
    }
    // Create the main Supp class.
    content += '---@class supp.Supp\n';
    content += '---@field VERSION string\n';
    for (const key in dict) {
        if (key === 'supp') {
            continue;
        }
        const split = key.split('.');
        const path = split[split.length - 1];
        content += `---@field ${path} ${key}\n`;
    }
    if (dict['supp']) {
        for (const name of dict['supp']) {
            content += `---@field ${name} supp.${name}\n`;
        }
    }
    content += '\n';
    // Create the Supp class table.
    content += 'return {\n';
    content += `  VERSION = '${VERSION}',\n`;
    for (const key in dict) {
        if (key === 'supp') {
            continue;
        }
        const split = key.split('.');
        const path = split[split.length - 1];
        content += `  ${path} = {\n`;
        for (const name of dict[key]) {
            content += `    ${name} = ${name},\n`;
        }
        content += '  },\n';
    }
    if (dict['supp']) {
        for (const name of dict['supp']) {
            content += `  ${name} = ${name},\n`;
        }
    }
    content += '}\n';
    return content;
}
