var express = require('express');
var router = express.Router();
const querySql = require('../db/index')
/* 添加导航类型接口 */
router.post('/add', async (req, res, next) => {
    let { typename} = req.body
    // let {username} = req.user
    try {
        let _type = await querySql('select * from types where typename = ?', [typename])
        if (!_type || _type.length === 0) {
            await querySql('insert into types(typename,cdate,status,editdate) value(?,NOW(),1,NOW())', [typename])
            res.send({ code: 0, msg: '导航类型添加成功' })
        } else {
            res.send({ code: -1, msg: '该导航类型已存在' })
        }
    } catch (e) {
        console.log(e)
        next(e)
    }
});
//   修改导航类型接口
router.post('/update', async (req, res, next) => {
    let { id, typename } = req.body
    try {
        let result = await querySql('update types set typename = ? where id = ?', [typename,id])
        res.send({ code: 0, msg: '导航类型修改成功' })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
//   删除导航类型接口
router.post('/delete', async (req, res, next) => {
    let { id } = req.body
    try {
        let result = await querySql('update types set status=0 where id = ?', [id])
        console.log(result);
        res.send({ code: 0, msg: '导航类型删除成功' })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
//获取导航类型详情接口 
router.post('/detail', async (req, res, next) => {
    let { id } = req.body
    try {
        let sql = 'select id,typename,DATE_FORMAT(cdate,"%Y-%m-%d %H:%i:%s") AS cdate from types where id = ?'
        let result = await querySql(sql, [id])
        res.send({ code: 0, msg: '导航类型获取成功', data: result[0] })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
// 获取导航类型列表接口
router.post('/allList', async (req, res, next) => {
    let {page=1,limit=10} = req.body
    try {
        let sql = `select id,typename,DATE_FORMAT(cdate,"%Y-%m-%d %H:%i:%s") AS cdate from types 
        where status = 1 limit ${(page-1)*limit},${limit}`
        let result = await querySql(sql,[page,limit]);
        let sql2="SELECT id FROM types where status = 1";
        let total_items = await querySql(sql2);
        let info={
            data:result,
            total_items:total_items.length
        }
        res.send({ code: 0, msg: '获取成功', data: info })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
// 获取导航类型映射接口
router.post('/list', async (req, res, next) => {
    try {
        let sql = `select id,typename,DATE_FORMAT(cdate,"%Y-%m-%d %H:%i:%s") AS cdate from types 
        where status = 1 `
        let result = await querySql(sql);
        res.send({ code: 0, msg: '获取成功', data: result })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
module.exports = router;