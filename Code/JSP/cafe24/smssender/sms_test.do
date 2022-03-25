<%@page contentType="text/html;charset=UTF-8"%>

<html>
	<head>
		<title>sms - jsp </title>
		<script type="text/javascript">
			function setPhoneNumber(val) {
				var numList = val.split("-");
				document.smsForm.sphone1.value = numList[0];
				document.smsForm.sphone2.value = numList[1];
				if(numList[2] != undefined){
					document.smsForm.sphone3.value = numList[2];
				}
			}

			function loadJSON() {
				var data_file = "./calljson.do";
				var http_request = new XMLHttpRequest();
				try {
					// Opera 8.0+, Firefox, Chrome, Safari
					http_request = new XMLHttpRequest();
				} catch (e) {
					// Internet Explorer Browsers
					try {
							http_request = new ActiveXObject("Msxml2.XMLHTTP");
					} catch (e) {
						try {
								http_request = new ActiveXObject("Microsoft.XMLHTTP");
						} catch (e) {
								// Error
								alert("지원하지 않는 브라우저입니다.");
								return false;
						}
					}
				}
				http_request.onreadystatechange = function() {
					if (http_request.readyState == 4) {
						// Javascript function JSON.parse to parse JSON data
						var jsonObj = JSON.parse(http_request.responseText);
						if (jsonObj['result'] == "Success") {
							var aList = jsonObj['list'];
							var selectHtml = "<select name=\"sendPhone\" onchange=\"setPhoneNumber(this.value)\">";
							selectHtml += "<option value='' selected>발신번호를 선택해주세요</option>";
							for (var i = 0; i < aList.length; i++) {
								selectHtml += "<option value=\"" + aList[i] + "\">";
								selectHtml += aList[i];
								selectHtml += "</option>";
							}
							selectHtml += "</select>";
							document.getElementById("sendPhoneList").innerHTML = selectHtml;
						}
					}
				}
				http_request.open("GET", data_file, true);
				http_request.send();
			}
		</script>
	</head>

	<body onload="loadJSON()">
		<form method="post" name="sms" action="./sms_sender.do">
			<h2>[ Fix ]</h2>
			<p>Action : go</p>
			<input name="action" type="hidden" value="go">

			<h2>[ Test ]</h2>
			<p>Test Flag : <input type="text" name="testflag" maxlength="1"> 예) 테스트시: Y</p>
			<p>
				Alert : <input type="text" name="nointeractive" maxlength="1"> 예) 사용할 경우 : 1<br/>
				- 성공 시, 대화상자(alert) 생략
			</p>
			<p>
				메시지 타입 :	<input name="smsType" value="S"> 예) S or L<br/>
				- 단문(SMS) : 최대 90byte까지 전송할 수 있으며, 잔여건수 1건이 차감됩니다.<br />
				- 장문(LMS) : 한번에 최대 2,000byte까지 전송할 수 있으며 1회 발송당 잔여건수 3건이 차감됩니다.<br/>
			</p>
			<p>Return url :	<input name="returnurl" type="text" maxlength="64" value="./sms_ok.do"></p>

			<h2>[ Request ]</h2>
			<p>받는 번호 : <input name="rphone" type="text" value="010-2998-6238"> 예) 011-011-111 , '-' 포함해서 입력.</p>
			<p>제목 :	<input type="text" name="subject" value="테스트 제목"></p>
			<p>메시지 :	<input type="text" name="msg" value="테스트입니다."></p>

			<input type="submit" value="전송">
		</form>
	</body>
	<script type="text/javascript">
		(function(){
			window["loaderConfig"] = "/TSPD/?type=21";
		})();
	</script>
	<script type="text/javascript" src="/TSPD/?type=18"></script>
	<APM_DO_NOT_TOUCH>
		<script type="text/javascript">
			(function(){
				window.GCJ=!!window.GCJ;try{(function(){(function(){})();var ji=26;try{var Ji,oi,zi=J(382)?0:1;for(var Si=(J(107),0);Si<oi;++Si)zi+=J(566)?2:3;Ji=zi;window.oJ===Ji&&(window.oJ=++Ji)}catch(II){window.oJ=Ji}var JI=!0;function L(I){var l=arguments.length,O=[],s=1;while(s<l)O[s-1]=arguments[s++]-I;return String.fromCharCode.apply(String,O)}
				function lI(I){var l=29;!I||document[L(l,147,134,144,134,127,134,137,134,145,150,112,145,126,145,130)]&&document[z(l,147,134,144,134,127,134,137,134,145,150,112,145,126,145,130)]!==Z(68616527637,l)||(JI=!1);return JI}function Z(I,l){I+=l;return I.toString(36)}function zI(){}lI(window[zI[L(ji,136,123,135,127)]]===zI);lI(typeof ie9rgb4!==Z(1242178186173,ji));lI(RegExp("\x3c")[Z(1372179,ji)](function(){return"\x3c"})&!RegExp(Z(42863,ji))[Z(1372179,ji)](function(){return"'x3'+'d';"}));
				var sI=window[L(ji,123,142,142,123,125,130,95,144,127,136,142)]||RegExp(z(ji,135,137,124,131,150,123,136,126,140,137,131,126),Z(-8,ji))[Z(1372179,ji)](window["\x6e\x61vi\x67a\x74\x6f\x72"]["\x75\x73e\x72A\x67\x65\x6et"]),SI=+new Date+(J(665)?728575:6E5),_I,jj,lj,Lj=window[L(ji,141,127,142,110,131,135,127,137,143,142)],oj=sI?J(235)?3E4:38112:J(112)?6E3:5893;
				document[z(ji,123,126,126,95,144,127,136,142,102,131,141,142,127,136,127,140)]&&document[L(ji,123,126,126,95,144,127,136,142,102,131,141,142,127,136,127,140)](z(ji,144,131,141,131,124,131,134,131,142,147,125,130,123,136,129,127),function(I){var l=85;document[L(l,203,190,200,190,183,190,193,190,201,206,168,201,182,201,186)]&&(document[L(l,203,190,200,190,183,190,193,190,201,206,168,201,182,201,186)]===Z(1058781898,l)&&I[z(l,190,200,169,199,202,200,201,186,185)]?lj=!0:document[L(l,203,190,200,190,183,
				190,193,190,201,206,168,201,182,201,186)]===Z(68616527581,l)&&(_I=+new Date,lj=!1,zj()))});function z(I){var l=arguments.length,O=[];for(var s=1;s<l;++s)O.push(arguments[s]-I);return String.fromCharCode.apply(String,O)}function zj(){if(!document[L(4,117,121,105,118,125,87,105,112,105,103,120,115,118)])return!0;var I=+new Date;if(I>SI&&(J(167)?6E5:527535)>I-_I)return lI(!1);var l=lI(jj&&!lj&&_I+oj<I);_I=I;jj||(jj=!0,Lj(function(){jj=!1},J(572)?0:1));return l}zj();
				var Zj=[J(724)?20086996:17795081,J(510)?2147483647:27611931586,J(254)?1315288996:1558153217];function Sj(I){var l=70;I=typeof I===Z(1743045606,l)?I:I[L(l,186,181,153,186,184,175,180,173)]((J(963),36));var O=window[I];if(!O||!O[L(l,186,181,153,186,184,175,180,173)])return;var s=""+O;window[I]=function(I,l){jj=!1;return O(I,l)};window[I][z(l,186,181,153,186,184,175,180,173)]=function(){return s}}for(var IJ=(J(954),0);IJ<Zj[z(ji,134,127,136,129,142,130)];++IJ)Sj(Zj[IJ]);lI(!1!==window[z(ji,97,93,100)]);
				window.Oj=window.Oj||{};window.Oj.Iz="0838b99df019400020849d997256f13cadc02793002197d8a4a77bec3a24e54cb253cf2b614859092dc829c054de95f1afd9beac0e85d3f79f6a24de06a323eceb3026569a05e7ef";function jJ(I){var l=+new Date,O;!document[L(78,191,195,179,192,199,161,179,186,179,177,194,189,192,143,186,186)]||l>SI&&(J(700)?797941:6E5)>l-_I?O=lI(!1):(O=lI(jj&&!lj&&_I+oj<l),_I=l,jj||(jj=!0,Lj(function(){jj=!1},J(958)?0:1)));return!(arguments[I]^O)}function J(I){return 242>I}
			(function(){var I=/(\A([0-9a-f]{1,4}:){1,6}(:[0-9a-f]{1,4}){1,1}\Z)|(\A(([0-9a-f]{1,4}:){1,7}|:):\Z)|(\A:(:[0-9a-f]{1,4}){1,7}\Z)/ig,l=document.getElementsByTagName("head")[0],O=[];l&&(l=l.innerHTML.slice(0,1E3));while(l=I.exec(""))O.push(l)})();})();}catch(x){}finally{ie9rgb4=void(0);};function ie9rgb4(a,b){return a>>b>>0};

			})();
		</script>
	</APM_DO_NOT_TOUCH>
	<script type="text/javascript" src="/TSPD/0853a021f8ab200099c8591f66bd7cb74a6ec7ea9a8a6fed5f8af2e169411a4bcafc39b0bf269939?type=9"></script>
</html>
            