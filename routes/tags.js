var express = require('express');
var router = express.Router();
const querySql = require('../db/index')
/* 添加标签接口 */
router.post('/add', async (req, res, next) => {
    let { tagname, tagdesc } = req.body
    // let {username} = req.user
    try {
        let tag = await querySql('select * from tag where tagname = ?', [tagname])
        if (!tag || tag.length === 0) {
            await querySql('insert into tag(tagname,tagdesc,cdate,status) value(?,?,NOW(),1)', [tagname, tagdesc])
            res.send({ code: 0, msg: '标签添加成功' })
        } else {
            res.send({ code: -1, msg: '该标签已存在' })
        }
    } catch (e) {
        console.log(e)
        next(e)
    }
});
//   修改标签接口
router.post('/update', async (req, res, next) => {
    let { id, tagname, tagdesc } = req.body
    try {
        let result = await querySql('update tag set tagname = ?,tagdesc = ? where id = ?', [tagname, tagdesc, id])
        res.send({ code: 0, msg: '标签修改成功' })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
//   删除标签接口
router.post('/delete', async (req, res, next) => {
    let { id } = req.body
    try {
        let result = await querySql('update tag set status=0 where id = ?', [id])
        res.send({ code: 0, msg: '标签删除成功' })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
//获取标签详情接口
router.post('/detail', async (req, res, next) => {
    let { id } = req.body
    try {
        let sql = 'select id,tagname,tagdesc,DATE_FORMAT(cdate,"%Y-%m-%d %H:%i:%s") AS cdate from tag where id = ?'
        let result = await querySql(sql, [id])
        res.send({ code: 0, msg: '获取成功', data: result[0] })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
// 获取标签列表接口
router.post('/allList', async (req, res, next) => {
    try {
        let sql =`select 
        id, tagname, tagdesc,DATE_FORMAT(cdate,"%Y-%m-%d %H:%i:%s") AS cdate,
        (SELECT COUNT(*) as artNum FROM article where status = 1 and FIND_IN_SET(T.id, tag) ) as artNum 
        from tag AS T 
        where T.status = 1;`
        //  `select id,tagname,tagdesc,DATE_FORMAT(cdate,"%Y-%m-%d %H:%i:%s") AS cdate,
        // ( SELECT COUNT(*) FROM article where FIND_IN_SET(id, tag) and status = 1) as artNum 
        // from tag where status = 1`
        let result = await querySql(sql);
        res.send({
            code: 0,
            msg: '获取列表成功',
            data: result
        })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
// 按标签获取文章列表
router.post('/articles', async (req, res, next) => {
    let { tag,page=1,limit=10 } = req.body
    try {
        let sql = `select id,arttitle, abstract,category,tag,thumbnail,content,html,pv,discuss, editdate, DATE_FORMAT(cdate,"%Y-%m-%d %H:%i:%s") AS cdate , 
        ( SELECT categorydesc FROM category where FIND_IN_SET(id, category) and status = 1) as categorydesc , 
        ( SELECT categoryname FROM category where FIND_IN_SET(id, category) and status = 1) as categoryname ,
        ( SELECT tagname FROM tag where FIND_IN_SET(id, tag) and status = 1) as tagname
        from article where tag=? and status=1 limit ${(page - 1) * limit},${limit}`
        let result = await querySql(sql, [tag,page,limit]);
        let sql1=`select id from article where  status=1 and tag=?`;
        let items= await querySql(sql1,[tag]);
        let info = {
            data: result,
            total_items:items.length
        }
        res.send({ code: 0, msg: '获取成功', data: info })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
module.exports = router;