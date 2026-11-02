#!/usr/bin/env node

/**
 * ClickUp Sync CLI Helper - FTN DevsIA
 * Uso:
 *   node scripts/clickup_sync.js create-feature "Nome da Feature" "Descrição"
 *   node scripts/clickup_sync.js create-subtask "FEATURE_TASK_ID" "Nome da Subtarefa" "Descrição"
 *   node scripts/clickup_sync.js update-status "TASK_ID" "STATUS_NAME"
 *   node scripts/clickup_sync.js add-comment "TASK_ID" "Comentário com link de docs/PR"
 */

const https = require('https');

const API_TOKEN = process.env.CLICKUP_API_TOKEN;
const LIST_ID = process.env.CLICKUP_TASKS_LIST_ID || process.env.CLICKUP_FEATURES_LIST_ID;

if (!API_TOKEN) {
  console.error("❌ ERRO: CLICKUP_API_TOKEN não configurado no ambiente local (.env).");
  process.exit(1);
}

function request(path, method, data) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'api.clickup.com',
      port: 443,
      path: `/api/v2${path}`,
      method: method,
      headers: {
        'Authorization': API_TOKEN,
        'Content-Type': 'application/json'
      }
    };

    const req = https.request(options, (res) => {
      let body = '';
      res.on('data', chunk => body += chunk);
      res.on('end', () => {
        try {
          const parsed = JSON.parse(body);
          resolve({ status: res.statusCode, data: parsed });
        } catch (e) {
          resolve({ status: res.statusCode, data: body });
        }
      });
    });

    req.on('error', reject);
    if (data) req.write(JSON.stringify(data));
    req.end();
  });
}

async function main() {
  const [,, cmd, arg1, arg2, arg3] = process.argv;

  switch (cmd) {
    case 'create-feature': {
      const name = arg1;
      const description = arg2 || '';
      console.log(`📋 Criando Feature no ClickUp: "${name}"...`);
      const res = await request(`/list/${LIST_ID}/task`, 'POST', {
        name: `[FEATURE] - ${name}`,
        description: description,
        status: 'Open'
      });
      console.log(`✅ Feature criada com sucesso! ID: ${res.data.id} - URL: ${res.data.url}`);
      break;
    }

    case 'create-subtask': {
      const parentId = arg1;
      const name = arg2;
      const description = arg3 || '';
      console.log(`🛠️ Criando Subtarefa vinculada ao ID ${parentId}: "${name}"...`);
      const res = await request(`/list/${LIST_ID}/task`, 'POST', {
        name: name,
        description: description,
        parent: parentId,
        status: 'Open'
      });
      console.log(`✅ Subtarefa criada! ID: ${res.data.id} - URL: ${res.data.url}`);
      break;
    }

    case 'update-status': {
      const taskId = arg1;
      const status = arg2;
      console.log(`🔄 Atualizando status da tarefa ${taskId} para "${status}"...`);
      const res = await request(`/task/${taskId}`, 'PUT', { status: status });
      console.log(`✅ Status atualizado com sucesso!`);
      break;
    }

    case 'add-comment': {
      const taskId = arg1;
      const commentText = arg2;
      console.log(`💬 Adicionando comentário na tarefa ${taskId}...`);
      await request(`/task/${taskId}/comment`, 'POST', { comment_text: commentText });
      console.log(`✅ Comentário registrado.`);
      break;
    }

    default:
      console.log(`Comandos disponíveis:
  create-feature <nome> <descricao>
  create-subtask <parent_task_id> <nome> <descricao>
  update-status <task_id> <status>
  add-comment <task_id> <comentario>`);
  }
}

main().catch(err => {
  console.error("❌ Falha na execução:", err.message);
  process.exit(1);
});
