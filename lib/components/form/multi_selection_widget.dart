import 'package:flutter/material.dart';
import "../../model/index.dart";
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_learning/theme/AppTheme.dart';
import 'package:flutter_learning/components/form/error_text_widget.dart';

class MultiSelectionWidget extends StatefulWidget {
  QuestionObj questionObj;

  MultiSelectionWidget({Key? key, required this.questionObj}) : super(key: key);

  @override
  State<MultiSelectionWidget> createState() => _MultiSelectionWidgetState();
}

class _MultiSelectionWidgetState extends State<MultiSelectionWidget> {
  final dropdownKey = GlobalKey<DropdownSearchState<dynamic>>();

  late List<OptionObj> options = [];
  late bool isReadOnly;
  late String title;
  late double titleFontSize;
  late bool titleBold;
  late double answerFontSize;
  late bool answerBold;
  late bool isVisible;
  late FieldDirection fieldDirection = FieldDirection.vertical;

  List<OptionObj> selectedOptions = [];

  List<OptionObj> getValue() {
    return selectedOptions;
  }

  @override
  void initState() {
    super.initState();
    title = widget.questionObj.title;
    titleFontSize = widget.questionObj.titleFontSize;
    titleBold = widget.questionObj.titleBold;
    answerFontSize = widget.questionObj.answerFontSize;
    answerBold = widget.questionObj.answerBold;
    isVisible = widget.questionObj.isVisible;
    isReadOnly = widget.questionObj.isReadOnly;
    fieldDirection = widget.questionObj.fieldDirection;
    options = widget.questionObj.options;
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: multiSelectionWidget(),
    );
  }

  Widget multiSelectionWidget() {
    return FormField(
      validator: (value) {
        if (selectedOptions.isEmpty) {
          return 'Please select an option';
        }
        return null;
      },
      builder: (FormFieldState state) {
        return Column(
          children: [
            fieldDirection == FieldDirection.vertical ? MultiSelectionWidget_Vertical(state: state) : MultiSelectionWidget_Horizontal(state: state),
          ],
        );
      },
    );
  }

  Widget dropdwonSearchMultiSelectionWidget() {
    return DropdownSearch<OptionObj>.multiSelection(
      key: dropdownKey,
      decoratorProps: const DropDownDecoratorProps(
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.fromLTRB(5, 5, 0, 5),
        ),
      ),
      popupProps: PopupPropsMultiSelection.dialog(
        showSelectedItems: true,
        scrollbarProps: ScrollbarProps(
          thumbVisibility: true,
        ),
        searchDelay: Duration(milliseconds: 0),
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0), // Adjust vertical padding
            constraints: BoxConstraints(maxHeight: 50.0), // Limit height
          ),
          style: TextStyle(fontSize: answerFontSize), // Set font size to 20
        ),
        itemBuilder: (BuildContext context, OptionObj item, bool isSelected, bool hasFocus) {
          return ListTile(
            title: Text(
              item.label,
              style: TextStyle(
                fontSize: answerFontSize,
                fontWeight: answerBold ? FontWeight.bold : FontWeight.normal,
                color: Colors.black,
              ),
            ),
            // trailing: isSelected ? Icon(Icons.check) : null,
          );
        },
        validationBuilder: (ctx, selectedItems) {
          return GestureDetector(
            onTap: () {
              dropdownKey.currentState?.popupOnValidate();
            },
            child: Container(
              color: Colors.blue.shade400,
              height: 56,
              child: Align(
                alignment: Alignment.center,
                child: Text("OK"),
              ),
            ),
          );
        },
        dialogProps: DialogProps(
          // Add this to customize the dialog shape
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Set to zero for no rounding
          ),
          backgroundColor: Colors.white,
        ),
      ),
      enabled: !isReadOnly,
      items: (filter, infiniteScrollProps) => options,
      itemAsString: (OptionObj u) => u.label,
      compareFn: (OptionObj obj1, OptionObj obj2) {
        return obj1.value == obj2.value;
      },
      onChanged: (List<OptionObj> obj) {
        setState(() {
          selectedOptions = obj;
        });
      },
      selectedItems: selectedOptions,
      dropdownBuilder: (context, dynamic? selectedItem) {
        return Wrap(
          children: selectedOptions.map((e) => SelectedItemWidget(e)).toList(),
        );
      },
    );
  }

  Widget MultiSelectionWidget_Vertical({required FormFieldState state}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: titleFontSize, fontWeight: titleBold ? FontWeight.bold : FontWeight.normal),
        ),
        SizedBox(height: 8.0),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: state.hasError ? AppTheme.of(context).error : Colors.grey),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: dropdwonSearchMultiSelectionWidget(),
        ),
        if (state != null && state.hasError) ErrorTextWidget(state: state),
      ],
    );
  }

  Widget SelectedItemWidget(dynamic item) {
    return Container(
      height: 32,
      padding: EdgeInsets.only(left: 10, right: isReadOnly ? 10 : 0),
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue.withOpacity(0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              item.label,
              style: TextStyle(fontSize: answerFontSize, fontWeight: answerBold ? FontWeight.bold : FontWeight.normal),
            ),
          ),
          Visibility(
              visible: !isReadOnly,
              child: Container(
                width: 36,
                child: MaterialButton(
                  height: 20,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(0),
                  minWidth: 20,
                  onPressed: () {
                    setState(() {
                      selectedOptions.remove(item);
                      dropdownKey.currentState?.removeItem(item);
                    });
                  },
                  child: Icon(
                    Icons.close_outlined,
                    size: 20,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget MultiSelectionWidget_Horizontal({required FormFieldState state}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(bottom: state.hasError ? 22.0 : 0),
              child: Text(
                title,
                style: TextStyle(fontSize: titleFontSize, fontWeight: titleBold ? FontWeight.bold : FontWeight.normal),
              ),
            )),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: state.hasError ? AppTheme.of(context).error : Colors.grey),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: dropdwonSearchMultiSelectionWidget(),
              ),
              if (state != null && state.hasError) ErrorTextWidget(state: state),
            ],
          ),
        ),
      ],
    );
  }
}
