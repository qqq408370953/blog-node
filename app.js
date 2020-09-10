var createError = require('http-errors');
var express = require('express');
var path = require('path');
var bodyParser = require('body-parser');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var cors = require('cors')
var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');
var tagsRouter = require('./routes/tags');
var categoryRouter = require('./routes/categorys');
var articleRouter = require('./routes/articles');
var navRouter = require('./routes/nav');
var typesRouter = require('./routes/types');
var app = express();
app.use(cors({
 //指定接收的地址
}));
//request entity too large问题
//app.use(express.json({limit: '5mb'}));
// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(logger('dev'));
//app.use(express.json(limit: '50mb'));
//app.use(express.urlencoded({ limit: '50mb',extended: true }));

app.use(bodyParser.json({limit: '50mb'}));
app.use(bodyParser.urlencoded({limit: '50mb', extended: true}));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/index', indexRouter);
app.use('/users', usersRouter);
app.use('/tags', tagsRouter);
app.use('/categorys', categoryRouter);
app.use('/articles', articleRouter);
app.use('/navs', navRouter);
app.use('/types', typesRouter);
// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
