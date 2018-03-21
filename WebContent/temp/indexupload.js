var app = require('express')();  
var http = require('http').Server(app);
var io = require('socket.io')(http);
var multer  = require('multer');  //파일 upload
var filesystem = require("fs");
var path = require('path');
var mime = require('mime');  //파일 download 
var port = process.env.PORT || 3000;
var num = 0;
var done = false;
var line=".211.238.142.20.";
/*var line="";*/
var urlencode = require('urlencode');  // 한글 url encoding 함수 사용




//현재 디렉터리에있는 파일을 results[] 에 넣는다
var _getAllFilesFromFolder = function(dir) {
    var results = [];
   filesystem.readdirSync(dir).forEach(function(file) {
        var filepath = dir+'/'+file;
        var stat = filesystem.statSync(filepath);
        if (stat && stat.isDirectory()) {
            results = results.concat(_getAllFilesFromFolder(filepath))
        } else results.push(file);

    });
    return results;

};


//upload에 관한 함수 multer 정의
var storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, './uploads/')
    },
    filename: function (req, file, cb) {
        cb(null, file.originalname)
    }
});

app.use(multer({ dest: './uploads/', storage : storage }).single('userPhoto'));

// upload시 action=내용
app.post('/photo', function(req, res){
	
	res.sendFile(__dirname + '/admin.html');
});

//url wildcard *   :downfile  parameter처리
app.get('/download/:downfile', function(req, res) {
	
	
	var downfile = req.params.downfile;
	  
    console.log(downfile);
	  
	  console.log(urlencode(downfile)); 
	
	  var imgfile=__dirname + '/uploads/'+downfile;
	
	//  console.log("file: "+imgfile);
	
	  var filename = path.basename(imgfile);
	  var mimetype = mime.lookup(imgfile);

	  res.setHeader('Content-disposition', 'attachment; filename=' + urlencode(downfile));
	  res.setHeader('Content-type', mimetype);

	  var filestream = filesystem.createReadStream(imgfile);
	  filestream.pipe(res);
});


/* url-Mapping */
app.get('/', function(req, res){
  res.sendFile(__dirname + '/index.html');
});
app.get('/index2.html', function(req, res){
	  res.sendFile(__dirname + '/index2.html');
	});
app.get('/admin', function(req, res){
	  res.sendFile(__dirname + '/admin.html');
	});


//socket io
io.on('connection', function(socket){
  socket.on('chat message', function(msg){
	if(msg=="admin"){ 
		num=0;
		console.log("admin");
		line=".211.238.142.20.";
	}
	else {	
	
	var chk = line.indexOf(msg);
	
	if(chk==-1&&msg!="*") {
		console.log(msg);
		line=line+msg+".";
		/*console.log(line);*/
		num++;
	}
	}
	var dirfile = _getAllFilesFromFolder(__dirname + "/uploads");
//	console.log(dirfile);

	/*var indexfile = dirfile.indexOf(dirfile);
	indexfile = dirfile.slice(indexfile, dirfile.length)
	console.log(dirfile);*/
	
	
	
    io.emit('chat message', num +":"+line+":"+dirfile);
  });
});

http.listen(port, function(){
  console.log('listening on *:' + port);
  console.log('__dirname *:' + __dirname);
});
