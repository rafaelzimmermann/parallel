const http = require("http");
const PORT = process.env.PORT || 8080;

const timer = ms => new Promise( res => setTimeout(res, ms));


const server = http.createServer(async (req, res) => {
    if (req.url.startsWith("/api/")) {
      delay = parseInt(req.url.replace("/api/", ""));
      timer(delay).then(_=> {
        res.writeHead(200, { "Content-Type": "application/json" });
        res.write("{\"delay\":" + delay + "}\n");
        res.end();
      });
    }

    else if (req.url === "/reset") {
      res.writeHead(200, { "Content-Type": "application/json" });
      res.write("OK");
      res.end();
    }

    // If no route present
    else {
        res.writeHead(404, { "Content-Type": "application/json" });
        res.end(JSON.stringify({ message: "Route not found" }));
    }
});

server.listen(PORT, () => {
    console.log(`server started on port: ${PORT}`);
});
