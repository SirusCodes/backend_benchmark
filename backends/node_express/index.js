const express = require("express");
const expressFileUpload = require("express-fileupload");
const bodyParser = require("body-parser");
const app = express();
const port = 8080;
const hostname = "127.0.0.1";

app.use(bodyParser.json({ limit: "50mb", strict: false }));

app.get("/", (_, res) => {
  res.send(JSON.stringify({ response: "Hello World!" }));
});

app.post("/echo", (req, res) => {
  res.send(JSON.stringify({ response: `Hello, ${req.body.name}!` }));
});

app.post("/json_obj", (req, res) => {
  const data = req.body;
  res.send(`${data.length}`);
});

app.post("/file_upload", expressFileUpload({ limits: {} }), (req, res) => {
  const file = req.files.benchmark;

  res.send(`${file.size}`);
});

app.listen(port, hostname, () => {
  console.log(`Example app listening on port ${hostname}:${port}`);
});
