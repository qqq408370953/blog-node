var express = require('express');
var router = express.Router();
const querySql = require('../db/index');
const {PWD_SALT,PRIVATE_KEY,EXPIRESD} = require('../utils/constant')
const {md5,upload}= require('../utils/index')
const jwt = require('jsonwebtoken')
// 注册接口
router.post('/register', async (req, res, next) => {
  let { username, password,nickname } = req.body
  try {
    let user = await querySql('select * from user where username = ?', [username])
    if (!user || user.length === 0) {
      password = md5(`${password}${PWD_SALT}`)
      await querySql('insert into user(username,password,nickname,cdate) value(?,?,NOW())', [username, password,nickname])
      res.send({ code: 0, msg: '注册成功' })
    } else {
    }
  } catch (e) {
    console.log(e)
    next(e)
  }
});
//登录接口
router.post("/login", async (req, res, next) => {
  let { username, password } = req.body;
  try {
    let user = await querySql('select *from user where username=?', [username])
    if (!user || user.length === 0) {
      res.send({ code: -1, msg: '该账号不存在' })
    } else {
      password = md5(`${password}${PWD_SALT}`)
      let result = await querySql('select *from user where username=?and password=?', [username, password])
      if (!result || result.length === 0) {
        res.send({ code: -1, msg: "账号或者密码不正确" })
      } else {
        let token = jwt.sign({username},PRIVATE_KEY,{expiresIn:EXPIRESD})
        let sql1 = 'select nickname,username from user where username = ?'
        let result = await querySql(sql1, [username])
        res.send({ code: 0, msg: "登录成功",token:token,info:result[0] })
      }
    }
  } catch (e) {
    console.log(e)
    next(e)
  }
})
//上传接口
router.post('/upload',upload.single('avatar'),async(req,res,next) => {
  let imgPath = req.file.path.split('public')[1]
  let imgUrl = 'http://localhost:5000/'+imgPath
  res.send({code:0,msg:'上传成功',data:imgUrl});
})
module.exports = router;
