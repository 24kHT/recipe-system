const fs = require("node:fs");
const http = require("node:http");
const path = require("node:path");

const root = path.join(process.cwd(), "dist");
const port = Number(process.env.PREVIEW_PORT || 4173);
const host = process.env.PREVIEW_HOST || "127.0.0.1";
const apiTarget = new URL(process.env.API_TARGET || "http://127.0.0.1:8080");
const types = {
  ".html": "text/html",
  ".js": "text/javascript",
  ".css": "text/css",
  ".json": "application/json",
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
  ".svg": "image/svg+xml",
};

function sendFile(res, file) {
  fs.readFile(file, (error, data) => {
    if (error) {
      res.writeHead(404);
      res.end("Not found");
      return;
    }
    const type = types[path.extname(file)] || "application/octet-stream";
    res.writeHead(200, { "Content-Type": `${type}; charset=utf-8` });
    res.end(data);
  });
}

http
  .createServer((req, res) => {
    if (req.url.startsWith("/api")) {
      const proxy = http.request(
        {
          hostname: apiTarget.hostname,
          port: apiTarget.port || 80,
          path: req.url,
          method: req.method,
          headers: req.headers,
        },
        (apiRes) => {
          res.writeHead(apiRes.statusCode || 502, apiRes.headers);
          apiRes.pipe(res);
        },
      );
      proxy.on("error", () => {
        res.writeHead(502, { "Content-Type": "application/json; charset=utf-8" });
        res.end(JSON.stringify({ code: 502, message: "后端服务不可用", data: null }));
      });
      req.pipe(proxy);
      return;
    }

    const routePath = decodeURIComponent(req.url.split("?")[0]);
    const requested = path.join(root, routePath === "/" ? "index.html" : routePath);
    if (!requested.startsWith(root)) {
      res.writeHead(403);
      res.end("Forbidden");
      return;
    }
    fs.access(requested, fs.constants.R_OK, (error) => {
      sendFile(res, error ? path.join(root, "index.html") : requested);
    });
  })
  .listen(port, host, () => {
    console.log(`preview http://${host}:${port}`);
  });
