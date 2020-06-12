formatNum(String str) { //格式化数字：例如  5000000.123 → 5,000,000.12  
  var newStr = ""; 
  var count = 0;
  if (str.indexOf(".") == -1) {
    for (var i = str.length - 1; i >= 0; i--) {
      if (count % 3 == 0 && count != 0) {
        newStr = str.substring(i,i+1) + "," + newStr; 
      } else {
        newStr = str.substring(i,i+1) + newStr; 
      } 
      count++; 
    } 
    str = newStr + ".00"; //自动补小数点后两位
    return str; 
  }else {  // 当数字带有小数
    for (var i = str.indexOf(".") - 1; i >= 0; i--) {
      if (count % 3 == 0 && count != 0) { 
        newStr = str.substring(i,i+1) + "," + newStr; 
      } else { 
        newStr = str.substring(i,i+1) + newStr; //逐个字符相接起来 
      }
      count++; 
    } 
    str = newStr + (str + "00").substring((str + "00").indexOf("."), (str + "00").indexOf(".")+3);
    return str;
    } 
  // return newStr;
}