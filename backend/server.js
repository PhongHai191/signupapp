const express = require("express");
const mysql = require("mysql2");

const app = express();
app.use(express.json());

const db = mysql.createPool({
  host: "mysql",
  user: "root",
  password: "password",
  database: "appdb",
  waitForConnections: true,
  connectionLimit: 10
});

app.post("/api/signup", (req, res) => {
  const { id, phone } = req.body;

  db.query(
    "INSERT INTO users (id, phone) VALUES (?, ?)",
    [id, phone],
    (err) => {
      if (err) {
        console.error(err);
        return res.status(500).send("DB error");
      }
      res.send("User added");
    }
  );
});

app.get("/api/users", (req, res) => {
  db.query("SELECT * FROM users", (err, result) => {
    if (err) {
      console.error(err);
      return res.status(500).send("DB error");
    }
    res.json(result);
  });
});

app.listen(3000, () => console.log("Backend running on port 3000"));