const age_limit = "EXPLICIT";
const no_result = "NO RESULT";

class ScrapingException implements Exception {
  String _errorMsg = "";

  ScrapingException([String state=""]) {
    this._errorMsg = state;
  }

  @override
  String toString(){
    return _errorMsg;
  }

  void errorHandler([String error=""]) {
    if(error==age_limit)
      throw new ScrapingException('🤔 노래 검색 에러\n성인인증이 필요한 곡입니다.');

    else if(error==no_result)
      throw new ScrapingException('🥲 해당 곡을 찾을 수 없습니다.');

    else
      throw new ScrapingException('😵 해당 곡의 가사를 찾을 수 없습니다.\n$error');
  }
}