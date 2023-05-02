import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../pages/layout/component/model/side_model.dart';
import 'extension.dart';

class DrawerSearch extends StatelessWidget {
  final String hint;
  final String label;
  final SearchableModel? controller;
  final String? Function(SearchableModel?)? validate;
  final List<SearchableModel> list;
  final Function(SearchableModel?)? onChange;

  const DrawerSearch(
      {Key? key,
      required this.hint,
      required this.label,
      required this.controller,
      this.validate,
      this.onChange,
      required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<SearchableModel>(
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
            hintText: hint,
            labelText: hint,
            prefixIcon: const Icon(Icons.search),
            // suffix: IconButton(onPressed: (){controller ="" ;}, icon: const Icon(Icons.close))
            // border: OutlineInputBorder(
            //   gapPadding: 1,
            //   borderRadius: BorderRadius.circular(8),
            // ),
            ),
      ),
      popupProps: PopupProps.menu(
        title: hint.toLabel(),
        showSearchBox: true,
        searchFieldProps: const TextFieldProps(
          autofocus: true,
        ),
      ),
      onChanged: onChange,
      validator: validate,
      selectedItem: controller,
      items: list,
      itemAsString: (SearchableModel u) => u.title,
    );
  }
}

class DropDownTextTwo extends StatelessWidget {
  final String hint;
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validate;
  final List<String> list;
  final Function(String?)? onChange;

  const DropDownTextTwo(
      {Key? key,
      required this.hint,
      required this.label,
      required this.controller,
      this.validate,
      this.onChange,
      required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      // dropdownDecoratorProps: DropDownDecoratorProps(
      //   dropdownSearchDecoration: InputDecoration(
      //     hintText: hint,
      //     labelText: hint,
      //     border: OutlineInputBorder(
      //       gapPadding: 20,
      //       borderRadius: BorderRadius.circular(8),
      //     ),
      //   ),
      // ),
      popupProps: PopupProps.menu(
        title: hint.toLabel(),
        showSearchBox: true,
        searchFieldProps: const TextFieldProps(
          autofocus: true,
        ),
      ),
      onChanged: onChange,
      validator: validate,
      selectedItem: controller.text,
      items: list,
    );
  }
}
