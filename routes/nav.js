var express = require('express');
var router = express.Router();
const querySql = require('../db/index')
/* 添加导航接口 */
router.post('/add', async (req, res, next) => {
    let { title, img, homeurl, githuburl, describes, details, detailhtml, types } = req.body
    // let {usertitle} = req.user
    try {
        let _title = await querySql('select * from nav where title = ?', [title])
        if (!_title || _title.length === 0) {
            let sql = 'insert into nav(title,img,homeurl,githuburl,describes,details,detailhtml,types,status,cdate,editdate) value(?,?,?,?,?,?,?,?,1,NOW(),NOW())';
            // let params={
            //     artTitle,abstract,category,tag,thumbnail,content,pv
            // }
            await querySql(sql, [title, img, homeurl, githuburl, describes, details, detailhtml, types])
            res.send({ code: 0, msg: '导航添加成功' })
        } else {
            res.send({ code: -1, msg: '该导航标题已存在' })
        }
    } catch (e) {
        console.log(e)
        next(e)
    }
});
//   修改导航接口
router.post('/update', async (req, res, next) => {
    let { title, img, homeurl, githuburl, describes, details, detailhtml, types, id } = req.body
    try {
        let sql = 'update nav set title = ?,img = ?,homeurl = ?,githuburl = ?,describes = ?,details = ?,detailhtml=?,types=? where id = ?'
        let result = await querySql(sql, [title, img, homeurl, githuburl, describes, details, detailhtml, types, id])
        res.send({ code: 0, msg: '导航修改成功' })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
//   删除导航接口
router.post('/delete', async (req, res, next) => {
    let { id } = req.body
    try {
        let result = await querySql('update nav set status=0 where id = ?', [id])
        res.send({ code: 0, msg: '导航删除成功' })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
//获取导航详情接口
router.post('/details', async (req, res, next) => {
    let { id } = req.body
    try {
        let sql = 'select title, img,homeurl,githuburl,describes,details,detailhtml,types,DATE_FORMAT(cdate,"%Y-%m-%d %H:%i:%s") AS cdate from nav where id = ?'
        let result = await querySql(sql, [id])
        res.send({ code: 0, msg: '获取详情成功', data: result[0] });
    } catch (e) {
        console.log(e)
        next(e)
    }
});
// 获取全部导航列表接口（未上线的除外）
router.post('/allList', async (req, res, next) => {
    let {page=1,limit=10} = req.body
    try {
        let sql = `select id,title, img,homeurl,githuburl,describes,details,detailhtml,types,DATE_FORMAT(cdate,"%Y-%m-%d %H:%i:%s") AS cdate 
        from nav where status = 1  limit ${(page-1)*limit},${limit}`
        let result = await querySql(sql,[page,limit]);
        let sql2="SELECT id FROM nav where status=1";
        let total_items = await querySql(sql2);
        let info={
            data:result,
            total_items:total_items.length
        }
        res.send({ code: 0, msg: '获取列表成功', data: info })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
// 后台获取全部导航列表接口（上线，未上线都有）
router.post('/allList/admin', async (req, res, next) => {
    let {page=1,limit=10} = req.body
    try {
        let sql = `select id,title,img,homeurl,githuburl,describes,details,detailhtml,types,status,DATE_FORMAT(cdate,"%Y-%m-%d %H:%i:%s") AS cdate from nav ORDER BY cdate desc
        limit ${(page-1)*limit},${limit}`
        let result = await querySql(sql,[page,limit]);
        let sql2="SELECT id FROM nav";
        let total_items = await querySql(sql2);
        let info={
            data:result,
            total_items:total_items.length
        }
        res.send({ code: 0, msg: '获取列表成功', data: info })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
//   导航状态修改接口
router.post('/changeStatus', async (req, res, next) => {
    let { id, status } = req.body
    try {
        let result = await querySql('update nav set status=? where id = ?', [status, id])
        res.send({ code: 0, msg: '导航状态修改成功' })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
// 按导航类型获取标签列表
router.post('/navlist', async (req, res, next) => {
    try {
        let sql = 'select id,typename from types where status = 1';
        let result = await querySql(sql);
        for (let i in result) {
            let sql1 = `SELECT id,title,homeurl,describes,types FROM nav where  types=? and status = 1`;
            let result1 = await querySql(sql1,[`${result[i].typename}`]);
            result[i].list = result1;
        }
        res.send({ code: 0, msg: '获取成功', data: result })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
module.exports = router;