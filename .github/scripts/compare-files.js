const fs = require('fs');
const path = require('path');

// Caminhos para as pastas salvas no workflow
const prDir = path.resolve('pr_files');
const targetDir = path.resolve('target_files');

// Função para obter todos os arquivos de um diretório recursivamente
function getAllFiles(dir, baseDir = dir) {
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  const files = entries.flatMap((entry) => {
    const fullPath = path.join(dir, entry.name);
    return entry.isDirectory() ? getAllFiles(fullPath, baseDir) : path.relative(baseDir, fullPath);
  });
  return files;
}

// Lista arquivos de ambas as versões
const prFiles = getAllFiles(prDir);
const targetFiles = getAllFiles(targetDir);

// Compara os arquivos entre a PR e a branch de destino
const addedFiles = prFiles.filter((file) => !targetFiles.includes(file));
const removedFiles = targetFiles.filter((file) => !prFiles.includes(file));
const modifiedFiles = prFiles.filter((file) => targetFiles.includes(file)).filter((file) => {
  const prFilePath = path.join(prDir, file);
  const targetFilePath = path.join(targetDir, file);
  return fs.readFileSync(prFilePath, 'utf-8') !== fs.readFileSync(targetFilePath, 'utf-8');
});

// Resultado final
const comparisonResults = {
  added: addedFiles,
  removed: removedFiles,
  modified: modifiedFiles,
};

// Salva os resultados para uso posterior
fs.writeFileSync('comparison-results.json', JSON.stringify(comparisonResults, null, 2));

console.log('Comparison completed!');
console.log(`Added files: ${JSON.stringify(addedFiles, null, 2)}`);
console.log(`Removed files: ${JSON.stringify(removedFiles, null, 2)}`);
console.log(`Modified files: ${JSON.stringify(modifiedFiles, null, 2)}`);
