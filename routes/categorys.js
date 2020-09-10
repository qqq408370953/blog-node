var express = require('express');
var router = express.Router();
const querySql = require('../db/index')
/* 添加分类接口 */
router.post('/add', async (req, res, next) => {
    let { categoryname, categorydesc } = req.body
    // let {username} = req.user
    try {
        let category = await querySql('select * from category where categoryname = ?', [categoryname])
        if (!category || category.length === 0) {
            await querySql('insert into category(categoryname,categorydesc,cdate,status) value(?,?,NOW(),1)', [categoryname, categorydesc])
            res.send({ code: 0, msg: '分类添加成功' })
        } else {
            res.send({ code: -1, msg: '该分类已存在' })
        }
    } catch (e) {
        console.log(e)
        next(e)
    }
});
//   修改分类接口
router.post('/update', async (req, res, next) => {
    let { id, categoryname, categorydesc } = req.body
    try {
        let result = await querySql('update category set categoryname = ?,categorydesc = ? where id = ?', [categoryname, categorydesc, id])
        res.send({ code: 0, msg: '分类修改成功' })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
//   删除分类接口
router.post('/delete', async (req, res, next) => {
    let { id } = req.body
    try {
        let result = await querySql('update category set status=0 where id = ?', [id])
        res.send({ code: 0, msg: '分类删除成功' })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
//获取分类详情接口
router.post('/detail', async (req, res, next) => {
    let { id } = req.body
    try {
        let sql = 'select id,categoryname,categorydesc,DATE_FORMAT(cdate,"%Y-%m-%d %H:%i:%s") AS cdate from category where id = ?'
        let result = await querySql(sql, [id])
        res.send({ code: 0, msg: '获取成功', data: result[0] })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
// 获取分类列表接口
// 获取全部分类列表接口
router.post('/allList', async (req, res, next) => {
    try {
        let sql = 'select id,categoryname,categorydesc,DATE_FORMAT(cdate,"%Y-%m-%d %H:%i:%s") AS cdate,( SELECT COUNT(*) FROM article where FIND_IN_SET(categoryname, category) and status = 1) as artNum from category where status = 1'
        let result = await querySql(sql)    
        res.send({ code: 0, msg: '获取成功', data: result })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
module.exports = router;