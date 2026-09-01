const fs = require('fs-extra');
const path = require('path');

async function packageForPages() {
  const distDir = path.join(__dirname, 'dist');
  const clientDir = path.join(distDir, 'client');
  const serverDir = path.join(distDir, 'server');
  const workerDir = path.join(distDir, '_worker.js');

  // Move client assets to root of dist
  if (fs.existsSync(clientDir)) {
    const files = fs.readdirSync(clientDir);
    for (const file of files) {
      fs.moveSync(path.join(clientDir, file), path.join(distDir, file), { overwrite: true });
    }
    fs.removeSync(clientDir);
  }

  // Move server dir to _worker.js dir
  if (fs.existsSync(serverDir)) {
    fs.moveSync(serverDir, workerDir, { overwrite: true });
    
    // Rename entry.mjs to index.js
    if (fs.existsSync(path.join(workerDir, 'entry.mjs'))) {
      fs.moveSync(path.join(workerDir, 'entry.mjs'), path.join(workerDir, 'index.js'), { overwrite: true });
    }
  }

  console.log("Packaged successfully for Cloudflare Pages!");
}

packageForPages().catch(console.error);
