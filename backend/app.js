const mysql = require("mysql2");
const express = require("express");
const bodyParser = require("body-parser");

const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

let db;

function connectDB() {

  db = mysql.createConnection({
    host: "mysql",
    user: "root",
    password: "password",
    database: "usersdb"
  });

  db.connect(err => {

    if (err) {
      console.log("MySQL not ready, retrying in 5 seconds...");
      setTimeout(connectDB, 5000);
    } else {
      console.log("MySQL Connected");
    }

  });

}

connectDB();

app.post("/api/signup", (req, res) => {
  const { id, phone } = req.body;

  db.query(
    "INSERT INTO users (id, phone) VALUES (?, ?)",
    [id, phone],
    (err, result) => {
      if (err) throw err;
      res.send("User added");
    }
  );
});

app.get("/api/users", (req, res) => {
  db.query("SELECT * FROM users", (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

app.listen(3000, () => {
  console.log("Backend running on port 3000");
});