<%@ page language="java" import="java.util.*, java.security.*, java.io.*, java.net.*" %>
<%!
  /**==============================================================
    Description        :  사용 함수 선언
  ==============================================================**/
  /**
  * nullcheck
  * @param str, Defaultvalue
  * @return
  */
  public static String nullcheck(String str,  String Defaultvalue ) throws Exception
  {
    String ReturnDefault = "" ;
    if (str == null)
    {
      ReturnDefault =  Defaultvalue ;
    }
    else if (str == "" )
    {
      ReturnDefault =  Defaultvalue ;
    }
    else
    {
      ReturnDefault = str ;
    }
    return ReturnDefault ;
  }

  /**
  * BASE64 Encoder
  * @param str
  * @return
  */
  public static String base64Encode(String str)  throws java.io.IOException {
    sun.misc.BASE64Encoder encoder = new sun.misc.BASE64Encoder();
    byte[] strByte = str.getBytes();
    String result = encoder.encode(strByte);
    return result ;
  }

  /**
  * BASE64 Decoder
  * @param str
  * @return
  */
  public static String base64Decode(String str)  throws java.io.IOException {
    sun.misc.BASE64Decoder decoder = new sun.misc.BASE64Decoder();
    byte[] strByte = decoder.decodeBuffer(str);
    String result = new String(strByte);
    return result ;
  }
%>
<%
  /**==============================================================
    Description        : 캐릭터셋 정의
    EUC-KR: @ page contentType="text/html;charset=EUC-KR
    UTF-8: @ page contentType="text/html;charset=UTF-8
  ==============================================================**/
%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%
  /**==============================================================
    Description        :  사용자 샘플코드
  ==============================================================**/
  String charsetType = "UTF-8"; // EUC-KR 또는 UTF-8

  request.setCharacterEncoding(charsetType);
  response.setCharacterEncoding(charsetType);
  String action = nullcheck(request.getParameter("action"), "");
  if(action.equals("go")) {

    // Default
    String sms_url = "https://sslsms.cafe24.com/sms_sender.php"; // SMS 전송요청 URL
    String user_id = base64Encode("아이디"); // SMS 아이디
    String secure = base64Encode("인증키"); // 인증키
    String sphone1 = base64Encode("02"); // 보내는 번호
    String sphone2 = base64Encode("번호");
    String sphone3 = base64Encode("입력");
    String mode = base64Encode("1");

    // Get via request
    String rphone = base64Encode(nullcheck(request.getParameter("rphone"), "")); // 받는 번호
    String subject = ""; // 제목
    String msg = base64Encode(nullcheck(request.getParameter("msg"), "")); // 메세지
    String smsType = base64Encode(nullcheck(request.getParameter("smsType"), ""));
    if(nullcheck(request.getParameter("smsType"), "").equals("L")) {
      // SMSType이 있으면 SMS, LMS를 구분해서 발송 처리
      // - value : S or L
      // - 단문(SMS) : 최대 90byte까지 전송할 수 있으며, 잔여건수 1건이 차감
      // - 장문(LMS) : 한번에 최대 2,000byte까지 전송할 수 있으며 1회 발송당 잔여건수 3건 차감
      subject = base64Encode(nullcheck(request.getParameter("subject"), ""));
    }
    // System.out.println("smsType"+smsType);

    // Etc
    String testflag = base64Encode(nullcheck(request.getParameter("testflag"), "")); // 테스트 시, Y
    String returnurl = nullcheck(request.getParameter("returnurl"), "./sms_ok.do");
    String nointeractive = nullcheck(request.getParameter("nointeractive"), ""); // 결과 alert

    String[] host_info = sms_url.split("/");
    String host = host_info[2];
    String path = "/" + host_info[3];
    int port = 80;

    // 데이터 맵핑 변수 정의
    String arrKey[]
        = new String[] {"mode", "user_id","secure","sphone1","sphone2","sphone3",
                      "rphone","subject","msg","testflag", "smsType"};
    String valKey[]= new String[arrKey.length] ;
    valKey[0] = mode;
    valKey[1] = user_id;
    valKey[2] = secure;
    valKey[3] = sphone1;
    valKey[4] = sphone2;
    valKey[5] = sphone3;
    valKey[6] = rphone;
    valKey[7] = subject;
    valKey[8] = msg;
    valKey[9] = testflag;
    valKey[10] = smsType;
    
    String boundary = "";
    Random rnd = new Random();
    String rndKey = Integer.toString(rnd.nextInt(32000));
    MessageDigest md = MessageDigest.getInstance("MD5");
    byte[] bytData = rndKey.getBytes();
    md.update(bytData);
    byte[] digest = md.digest();
    for(int i =0;i<digest.length;i++)
    {
      boundary = boundary + Integer.toHexString(digest[i] & 0xFF);
    }
    boundary = "---------------------"+boundary.substring(0,11);

    // 본문 생성
    String data = "";
    String index = "";
    String value = "";
    
    for (int i=0;i<arrKey.length; i++)
    {
      index =  arrKey[i];
      value = valKey[i];
      data +="--"+boundary+"\r\n";
      data += "Content-Disposition: form-data; name=\""+index+"\"\r\n";
      data += "\r\n"+value+"\r\n";
      data +="--"+boundary+"\r\n";
    }

    //out.println(data);

    InetAddress addr = InetAddress.getByName(host);
    Socket socket = new Socket(host, port);

    // 헤더 전송
    BufferedWriter wr = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream(), charsetType));
    wr.write("POST "+path+" HTTP/1.0\r\n");
    wr.write("Content-Length: "+data.length()+"\r\n");
    wr.write("Content-type: multipart/form-data, boundary="+boundary+"\r\n");
    wr.write("\r\n");

    // 데이터 전송
    wr.write(data);
    wr.flush();

    // 결과 값 얻기
    BufferedReader rd = new BufferedReader(new InputStreamReader(socket.getInputStream(),charsetType));
    String line;
    String alert = "";
    ArrayList tmpArr = new ArrayList();
    while ((line = rd.readLine()) != null) {
      tmpArr.add(line);
    }
    wr.close();
    rd.close();

    String tmpMsg = (String)tmpArr.get(tmpArr.size()-1);
    String[] rMsg = tmpMsg.split(",");
    String Result= rMsg[0]; // 발송결과
    String Count= ""; // 잔여건수
    if(rMsg.length>1) {Count= rMsg[1]; }

    System.out.println(Result);
    // 발송 결과 알림
    if(Result.equals("success")) {
      alert = "성공적으로 발송하였습니다.";
      alert += " 잔여건수는 "+ Count+"건 입니다.";
    }
    else if(Result.equals("reserved")) {
      alert = "성공적으로 예약되었습니다";
      alert += " 잔여건수는 "+ Count+"건 입니다.";
    }
    else if(Result.equals("3205")) {
      alert = "잘못된 번호형식입니다.";
    }
    else {
      alert = "[Error]"+Result;
    }

    out.println(nointeractive);

    if(nointeractive.equals("1") && !(Result.equals("Test Success!")) && !(Result.equals("success")) && !(Result.equals("reserved")) ) {
        out.println("<script>alert('" + alert + "')</script>");
    }
    else if(!(nointeractive.equals("1"))) {
        out.println("<script>alert('" + alert + "')</script>");
    }

    out.println("<script>location.href='"+returnurl+"';</script>");
  }
%>
                