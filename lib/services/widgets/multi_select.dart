import 'package:ams/services/utils/model.dart';
import 'package:ams/services/widgets/extension.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

import 'waiting.dart';

class MultiSelect extends StatelessWidget {
  final Function(List<String>) onChange;
  final List<String> selected;
  final List<String> items;
  final String hint;
  // final String Function(String?)? validate;
  final bool isLoading;

  const MultiSelect(
      {Key? key,
      required this.onChange,
      required this.selected,
      required this.items,
      // this.validate,
      this.isLoading = false,
      required this.hint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const MWaiting()
        : DropDownMultiSelect(
            options: items,
            // validator: validate,
            selectedValues: selected,
            whenEmpty: hint,
            onChanged: onChange);
  }
}

class MultiSelectModel extends StatelessWidget {
  final String hint;
  final String label;
  final bool isLoading;
  final List<DropDownModel> controller;
  final bool validate;
  final List<DropDownModel> list;
  final Function(List<DropDownModel>)? onChange;

  const MultiSelectModel(
      {Key? key,
      required this.hint,
      required this.label,
      required this.controller,
      this.isLoading = false,
      this.validate = false,
      this.onChange,
      required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const MWaiting()
        : validate
            ? DropdownSearch<DropDownModel>.multiSelection(
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    hintText: hint,
                    labelText: hint,
                    border: OutlineInputBorder(
                      gapPadding: 20,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                popupProps: PopupPropsMultiSelection.menu(
                  title: hint.toLabel(),
                  showSearchBox: true,
                  searchFieldProps: const TextFieldProps(
                    autofocus: true,
                  ),
                ),
                selectedItems: controller,
                validator: (List<DropDownModel>? list) =>
                    list == null ? 'Please this field is required' : null,
                onChanged: onChange,
                items: list,
                itemAsString: (DropDownModel u) => u.name,
              )
            : DropdownSearch<DropDownModel>.multiSelection(
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    hintText: hint,
                    labelText: hint,
                    border: OutlineInputBorder(
                      gapPadding: 20,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                popupProps: PopupPropsMultiSelection.menu(
                  title: hint.toLabel(),
                  showSearchBox: true,
                  searchFieldProps: const TextFieldProps(
                    autofocus: true,
                  ),
                ),
                selectedItems: controller,
                onChanged: onChange,
                items: list,
                itemAsString: (DropDownModel u) => u.name,
              );
  }
}
