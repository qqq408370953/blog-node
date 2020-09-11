var express = require('express');
var router = express.Router();
const querySql = require('../db/index');
const request = require('request');
/* 添加标签接口 */
router.post('/add', async (req, res, next) => {
    let {
        arttitle,
        abstract,
        category,
        tag,
        thumbnail,
        content,
        html,
        pv
    } = req.body
    // let {username} = req.user
    try {
        let article = await querySql('select * from article where arttitle = ?', [arttitle])
        if (!article || article.length === 0) {
            let sql = 'insert into article(arttitle, abstract,category,tag,thumbnail,content,html,cdate,pv,discuss,status,editdate) value(?,?,?,?,?,?,?,NOW(),?,0,1,NOW())';
            let result = await querySql(sql, [arttitle, abstract, category, tag, thumbnail, content, html, pv]);
            let msg=null;
            request.post({
                url: `http://data.zz.baidu.com/urls?site=www.xxx.com&token=u2H3rPTaDryJWq7P`, //xxx为自己的网站域名
                headers: { 'Content-Type': 'text/plain' },
                body: `www.xxx.com/article/${result.insertId}`
            }, (error, response, body) => {
                console.log(response);
                console.log('推送结果：', body);
                msg=response;
            })
            let info={
                id:result.insertId,
                body:msg
            }
            res.send({
                code: 0,
                msg: '文章添加成功',
                data: info,
            })
        } else {
            res.send({
                code: -1,
                msg: '该文章标题已存在'
            })
        }
    } catch (e) {
        console.log(e)
        next(e)
    }
});
//   修改文章接口
router.post('/update', async (req, res, next) => {
    let {
        arttitle,
        abstract,
        category,
        tag,
        thumbnail,
        content,
        html,
        pv,
        id
    } = req.body
    try {
        let sql = 'update article set arttitle = ?,abstract = ?,category = ?,tag = ?,thumbnail = ?,content = ?,html=?,pv = ? where id = ?'
        let result = await querySql(sql, [arttitle, abstract, category, tag, thumbnail, content, html, pv, id]);
        let msg=null;
        request.post({
            url: `http://data.zz.baidu.com/urls?site=www.xxx.com&token=u2H3rPTaDryJWq7P`,//xxx为自己的网站域名
            headers: { 'Content-Type': 'text/plain' },
            body: `www.xxx.com/article/${id}`
        }, (error, response, body) => {
            console.log(response);
            console.log('推送结果：', body);
            msg=response;
        })
        let info={
            id:id,
            body:msg
        }
        res.send({
            code: 0,
            msg: '文章修改成功',
            info:info
        })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
//   删除文章接口
router.post('/delete', async (req, res, next) => {
    let {
        id
    } = req.body
    try {
        let result = await querySql('update article set status=0 where id = ?', [id])
        res.send({
            code: 0,
            msg: '文章删除成功'
        })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
//获取文章详情接口
router.post('/detail', async (req, res, next) => {
    let {
        id
    } = req.body
    try {
        let sql = `select arttitle, abstract,category,tag,thumbnail,content,html,pv,discuss,DATE_FORMAT(cdate,"%Y-%m-%d %H:%i:%s") AS cdate, 
        ( SELECT categorydesc FROM category where FIND_IN_SET(id, category) and status = 1) as categorydesc , 
        ( SELECT categoryname FROM category where FIND_IN_SET(id, category) and status = 1) as categoryname ,
        ( SELECT tagname FROM tag where FIND_IN_SET(id, tag) and status = 1) as tagname
        from article where id = ?`
        let result = await querySql(sql, [id]);
        let articleDetail = result[0];
        if (articleDetail.pv >= 0) {
            const newPv = articleDetail.pv + 1;
            let pv = newPv;
            let sql = 'update article set pv = ? where id = ?'
            await querySql(sql, [pv, id]);
        }
        res.send({
            code: 0,
            msg: '获取详情成功',
            data: articleDetail
        });
    } catch (e) {
        console.log(e)
        next(e)
    }
});
// 获取全部博客列表接口（未上线的除外）
router.post('/allList', async (req, res, next) => {
    let { page = 1, limit = 10 } = req.body
    try {
        let sql = `select id,arttitle, abstract,category,tag,thumbnail,content,html,pv,discuss, editdate, DATE_FORMAT(cdate,"%Y-%m-%d %H:%i:%s") AS cdate, 
        ( SELECT categorydesc FROM category where FIND_IN_SET(id, category) and status = 1) as categorydesc , 
        ( SELECT categoryname FROM category where FIND_IN_SET(id, category) and status = 1) as categoryname ,
        ( SELECT tagname FROM tag where FIND_IN_SET(id, tag) and status = 1) as tagname 
        from article where status = 1  ORDER BY cdate desc  limit ${(page - 1) * limit},${limit}`
        let result = await querySql(sql, [page, limit]);
        let sql2 = "SELECT id FROM article where status = 1";
        let total_items = await querySql(sql2);
        let info = {
            data: result,
            total_items: total_items.length
        }
        res.send({
            code: 0,
            msg: '获取列表成功',
            data: info
        })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
// 后台获取全部博客列表接口（上线，未上线都有）
router.post('/allList/admin', async (req, res, next) => {
    let { page = 1, limit = 10 } = req.body
    try {
        let sql = `select id,arttitle, status, abstract,category,tag,thumbnail,content,html,pv,discuss, editdate, DATE_FORMAT(cdate,"%Y-%m-%d %H:%i:%s") AS cdate, 
        ( SELECT categorydesc FROM category where FIND_IN_SET(id, category) and status = 1) as categorydesc , 
        ( SELECT categoryname FROM category where FIND_IN_SET(id, category) and status = 1) as categoryname ,
        ( SELECT tagname FROM tag where FIND_IN_SET(id, tag) and status = 1) as tagname
        from article 
        ORDER BY cdate desc limit ${(page - 1) * limit},${limit}`
        let result = await querySql(sql, [page, limit]);
        let sql2 = "SELECT id FROM article";
        let total_items = await querySql(sql2);
        let info = {
            data: result,
            total_items: total_items.length
        }
        res.send({
            code: 0,
            msg: '获取列表成功',
            data: info
        })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
//   文章状态修改接口
router.post('/changeStatus', async (req, res, next) => {
    let {
        id,
        status
    } = req.body
    try {
        let result = await querySql('update article set status=? where id = ?', [status, id])
        res.send({
            code: 0,
            msg: '文章状态修改成功'
        })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
// 获取热门博客列表接口
router.post('/hostList', async (req, res, next) => {
    try {
        let sql = 'select id,arttitle, abstract,pv from article  limit 10 where status = 1  ORDER BY pv DESC;'
        let result = await querySql(sql)
        res.send({
            code: 0,
            msg: '获取热门文章成功',
            data: result
        })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
// 模糊查询文章
router.post('/selectTitle', async (req, res, next) => {
    let {val,page = 1, limit = 10 } = req.body
    try {
        let sql = `select A.id,A.arttitle, A.abstract,A.category,A.tag,A.thumbnail,A.content,A.html,A.pv,A.discuss, A.editdate, DATE_FORMAT(A.cdate,"%Y-%m-%d %H:%i:%s") AS cdate, 
        ( SELECT categorydesc FROM category where FIND_IN_SET(id, A.category) and status = 1) as categorydesc , 
        ( SELECT categoryname FROM category where FIND_IN_SET(id, A.category) and status = 1) as categoryname ,
        ( SELECT tagname FROM tag where FIND_IN_SET(id, A.tag) and status = 1) as tagname 
        from article as A 
        where (
            A.artTitle like "%${val}%"
            or
            A.content like "%${val}%"
            or
            A.abstract like "%${val}%"
        )
        AND A.status = 1
        ORDER BY A.cdate desc  
        limit ${(page - 1) * limit},${limit}`;
        let result = await querySql(sql, [val,page, limit]);
        console.log(result);
        let sql2 = `SELECT A.id,A.arttitle,A.abstract,A.content FROM article as A 
        where (
            A.artTitle like "%${val}%"
            or
            A.content like "%${val}%"
            or
            A.abstract like "%${val}%"
        )
        AND A.status = 1`;
        let total_items = await querySql(sql2,[val]);
        let info = {
            data: result,
            total_items: total_items.length
        }
        res.send({
            code: 0,
            msg: '获取列表成功',
            data: info
        })
    } catch (e) {
        console.log(e)
        next(e)
    }
});
module.exports = router;