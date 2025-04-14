import 'package:flutter/material.dart';
import "../../model/index.dart";
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_learning/theme/AppTheme.dart';
import './error_text_widget.dart';

class SingleSelectionWidget extends StatefulWidget {
  QuestionObj questionObj;

  SingleSelectionWidget({Key? key, required this.questionObj}) : super(key: key);

  @override
  State<SingleSelectionWidget> createState() => _SingleSelectionWidgetState();
}

class _SingleSelectionWidgetState extends State<SingleSelectionWidget> {
  late List<OptionObj> options = [];
  late bool isReadOnly;
  late String title;
  late double titleFontSize;
  late bool titleBold;
  late double answerFontSize;
  late bool answerBold;
  late bool isVisible;
  late FieldDirection fieldDirection = FieldDirection.vertical;

  OptionObj selectedOption = OptionObj(label: "", value: "");

  OptionObj getValue() {
    return selectedOption;
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

  CrossAxisAlignment getAlignment() {
    switch (widget.questionObj.titleAlignment) {
      case TextAlignment.centerLeft:
        return CrossAxisAlignment.start;
      case TextAlignment.centerRight:
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: singleSelectinWidget(),
    );
  }

  Widget singleSelectinWidget() {
    return FormField(
      validator: (value) {
        if (selectedOption.value != null && selectedOption.value!.isEmpty) {
          return 'Please select an option';
        }
        return null;
      },
      builder: (FormFieldState state) {
        return Column(
          children: [
            fieldDirection == FieldDirection.vertical ? SingleSelectionWidget_Vertical(state: state) : SingleSelectionWidget_Horizontal(state: state),
          ],
        );
      },
    );
  }

  Widget itemListBuilder(BuildContext context, OptionObj item, bool isSelected) {
    return ListTile(
      title: Text(
        item.label,
        style: TextStyle(fontSize: answerFontSize, fontWeight: answerBold ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }

  Widget SelectedItemBuilder(BuildContext context, dynamic? selectedItem) {
    return Text(selectedOption.label ?? "", style: TextStyle(fontSize: answerFontSize, fontWeight: answerBold ? FontWeight.bold : FontWeight.normal));
  }

  Widget SingleSelectionWidget_Vertical({required FormFieldState state}) {
    return Column(
      crossAxisAlignment: getAlignment(),
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
          child: DropdownSearch<OptionObj>(
            decoratorProps: const DropDownDecoratorProps(
                decoration: InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 12))),
            popupProps: PopupProps.menu(
              showSelectedItems: true,
              itemBuilder: (BuildContext context, OptionObj item, bool isSelected, bool hasFocus) {
                return itemListBuilder(context, item, isSelected);
              },
            ),
            enabled: !isReadOnly,
            items: (filter, infiniteScrollProps) => options,
            itemAsString: (OptionObj u) => u.label,
            compareFn: (OptionObj obj1, OptionObj obj2) {
              return obj1.value == obj2.value;
            },
            onChanged: (OptionObj? obj) {
              setState(() {
                selectedOption = obj!;
              });
            },
            //selectedItem
            dropdownBuilder: (context, dynamic? selectedItem) {
              return SelectedItemBuilder(context, selectedItem);
            },
          ),
        ),
        if (state.hasError) ErrorTextWidget(state: state) // Add some spacing between the title and the TextFormField
      ],
    );
  }

  Widget SingleSelectionWidget_Horizontal({required FormFieldState state}) {
    return Row(
      crossAxisAlignment: getAlignment(),
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
                child: DropdownSearch<OptionObj>(
                  decoratorProps: const DropDownDecoratorProps(
                      decoration: InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 12))),
                  popupProps: PopupProps.menu(
                    showSelectedItems: true,
                    itemBuilder: (BuildContext context, OptionObj item, bool isSelected, bool hasFocus) {
                      return itemListBuilder(context, item, isSelected);
                    },
                  ),
                  enabled: !isReadOnly,
                  items: (filter, infiniteScrollProps) => options,
                  itemAsString: (OptionObj u) => u.label,
                  compareFn: (OptionObj obj1, OptionObj obj2) {
                    return obj1.value == obj2.value;
                  },
                  onChanged: (OptionObj? obj) {
                    setState(() {
                      selectedOption = obj!;
                    });
                  },
                  //selectedItem
                  dropdownBuilder: (context, dynamic? selectedItem) {
                    return SelectedItemBuilder(context, selectedItem);
                  },
                ),
              ),
              if (state.hasError) ErrorTextWidget(state: state) // Add some spacing between the title and the TextFormField
            ],
          ), //
        ),
      ],
    );
  }
}
