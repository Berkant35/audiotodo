import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchTextManager extends StateNotifier<String>{
  SearchTextManager(String state) : super("");
  late TextEditingController _currentController;
  ScrollController? scrollController;
  bool requiredRefreshList = false;

  void addController(TextEditingController controller){
    _currentController = controller;
    _currentController.addListener(listenText);
  }

  void listenText(){
    state = _currentController.text;
    requiredRefreshList = true;

    if(scrollController != null){
      scrollController!.notifyListeners();
    }
  }

  void setScrollController(ScrollController controller){
    scrollController = controller;
  }

  void updateRequireStateToFalse(){
    requiredRefreshList = false;
  }

  //You can clear all filter
  void clearFilterText(TextEditingController controller){
    controller.clear();
    state = "";
  }
}