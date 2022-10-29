const express = require("express");
const bodyParser = require("body-parser");
const app = express();
const port = 8080;
const hostname = "127.0.0.1";

app.use(bodyParser.json());

app.get("/", (_, res) => {
  res.send("Hello World!");
});

app.post("/echo", (req, res) => {
  res.send(JSON.stringify({ response: `Hello, ${req.body.name}!` }));
});

app.listen(port, hostname, () => {
  console.log(`Example app listening on port ${hostname}:${port}`);
});
