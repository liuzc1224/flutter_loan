import 'address.dart';

class Api {
  static String user_check = "/user/register/check"; //校验用户信息是否已经注册
  static String login = "/user/login"; //用户登录
  static String register = "/user/register"; //用户注册
  static String send_verification_code =
      "/verification/code"; //获取手机验证码 1注册 2重置登录 3重置支付
  static String check_code = "/verification/code/check"; //校验手机验证码 1注册 2重置登录 3重置支付
  static String check_verification_code = "/verification/code/check"; //校验验证码
  static String checkChannel = "/user/register/checkChannel"; //查询邀请码是否开启
  static String invitationCode = "/user/register/invitationCode"; //保存邀请码
  static String update_password = "/user/login/password/update"; //修改登录密码
  static String forget_password = "/user/login/password/forget"; //忘记登录密码

  ///认证模块接口
  static String saveTime = "/burying/saveTime"; //统计信息填写时间
  static String workImageShow = "/business/param"; //判断工作证明是否必填

  static String identity = "/user/authentication"; //身份认证
  static String person = "/user/info"; //个人信息
  static String workInfo = "/user/work"; //工作信息
  static String contactInfo = "/user/contact"; //通讯录信息
  ///首页
  static String bannerInfo = "/homepage/recommends"; //首页banner
  static String headPortrait = "/user/info/head/portrait"; //保存头像
  static String getDetail = "/user/info/getDetail"; //查看用户详细信息
  static String homeStatus = "/homePage"; //首页状态判断
  static String getProduct = "/loanproduct"; //首页状态判断

  ///借款详情页
  static String loanProductInfo = "/loanproduct/"; //获取借款产品信息
  static String repayInfo = "/loanproduct/repayAmount"; //获取还款信息
  static String commitOrder = "/creditOrder/create"; //提交订单
  static String openFaceType =
      "/business/param/getCheckLivingBodyParam"; //获取活体选择
  static String commitAdvance =
      "/user/authentication/advanceai/detectLiveness"; //提交advance活体信息
  static String commitYitu="/user/authentication/saveYiTu";//提交衣图信息
  static String failProductInfo="/order/paymentfail";// 失败


  static String message_unread = "/message/unread"; //获取用户未读消息
  static String getCall = "/system/help/contact"; //帮助中心获取联系方式
  static String logout = "/user/logout"; //登出
  static String bankPersonal = "/bank/personal"; //查询个人银行卡列表
  static String bankAdd = "/bank/binding"; //添加绑定银行卡
  static String bankUpdate = "/bank"; //更新绑定的银行卡
  static String bankSupport = "/bank/support"; //查询支持银行卡列表
  static String bankDelete = "/bank/unbinding/"; //解绑银行卡
}

class H5 {
  static String msgCenter = Address.PAGE_URL+"/msgCenter"; //消息中心
  static String feedBack =Address.PAGE_URL+ "/feed-back"; //意见反馈
  static String historicalOrder =Address.PAGE_URL+ "/historical-order"; //历史订单
  static String coupon = Address.PAGE_URL+"/coupon"; //我的优惠券
  static String helpCenter = Address.PAGE_URL+"/help-center"; //帮助中心
  static String inviteRegistered =Address.PAGE_URL+ "/invite-registered"; //预注册
  static String selectCoupon =Address.PAGE_URL+ "/coupon-select"; //选择优惠券
  static String loanContract =Address.PAGE_URL+ "/loan-contract"; //借款合同
  static String toRepay = Address.PAGE_URL+"/repayment-detail"; //还款
  static String privacyAgreement = Address.PAGE_URL+"privacy-agreement"; //隐私协议
}
