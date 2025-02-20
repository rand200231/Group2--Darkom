import 'package:flutter/material.dart';

class SearchFilterWidget extends StatefulWidget {
  const SearchFilterWidget({super.key, required this.selectedCategories, required this.selectedCities, required this.categories, this.onChanged, required this.cities});
  
  final List<String> selectedCategories;
  final List<String> selectedCities;
  final List<String> categories;
  final List<String> cities;

  final void Function(List<String> selectedCategories, List<String> selectedCities)? onChanged;

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  
  List<String> selectedCategories = [];
  List<String> selectedCities = [];

  // List<String> categories = [
  //    'Adventure', 'Culture', 'Food',
  // ];
  late List<String> categories;
  // List<String> saudiCities = [
  //   "Riyadh", "Jeddah", "Qassim", "Al Ula", "Asir",
  // ];

  @override
  void initState() {
    super.initState();
    categories = widget.categories;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      selectedCategories = widget.selectedCategories;
      selectedCities = widget.selectedCities;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        color: Color(0XFFEEEEEE),
        borderRadius: BorderRadius.circular(30),
        // border: Border.all(color: const Color(0xFF000000), width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Scaffold(
        backgroundColor: Color(0XFFEEEEEE),
        body: ListView(
          shrinkWrap: true,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0XFF4d2f14),
              ),
            ),
      
            // do check box for the choices: all, Adventure, Lucture, Food
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    // itemCount: (categories.length / 2).toInt(),
                    itemCount: categories.length,
                    itemBuilder: (context, index) => CheckboxListTile(
                      value: selectedCategories.contains(categories[index]),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      visualDensity: VisualDensity(vertical: -4),
                      onChanged: (value) {
                        // selectedCategories = value ?? 'All';
                        if (value!) {
                          selectedCategories.add(categories[index]);
                        } else {
                          selectedCategories.remove(categories[index]);
                        }
                        setState(() {});
                        widget.onChanged?.call(selectedCategories, selectedCities);
                      },
                      title: Text(categories[index]),
                    ), 
                  ),
                ),
                // Expanded(
                //   child: ListView.builder(
                //     shrinkWrap: true,
                //     itemCount: (categories.length / 2).ceil(),
                //     itemBuilder: (context, index) => CheckboxListTile(
                //       value: selectedCategories.contains(categories[(categories.length / 2).toInt() + index]),
                //       controlAffinity: ListTileControlAffinity.leading,
                //       contentPadding: EdgeInsets.zero,
                //       visualDensity: VisualDensity(vertical: -4),
                //       onChanged: (value) {
                //         // selectedCategories = value ?? 'All';
                //         if (value == true) {
                //           selectedCategories.add(categories[(categories.length / 2).toInt() + index]);
                //         } else {
                //           selectedCategories.remove(categories[(categories.length / 2).toInt() + index]);
                //         }
                //         setState(() {});
                //         widget.onChanged?.call(selectedCategories, selectedCities);
                //       },
                //       title: Text(categories[(categories.length / 2).toInt() + index]),
                //     ), 
                //   ),
                // ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 20),
      
            Text(
              'City',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0XFF4d2f14),
              ),
            ),
      
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: (widget.cities.length / 2).toInt(),
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) => CheckboxListTile(
                      value: selectedCities.contains(widget.cities[index]),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      visualDensity: VisualDensity(vertical: -4),
                      onChanged: (value) {
                        if (value!) {
                          selectedCities.add(widget.cities[index]);
                        } else {
                          selectedCities.remove(widget.cities[index]);
                        }
                        setState(() {});
                        widget.onChanged?.call(selectedCategories, selectedCities);
                      },
                      title: Text(widget.cities[index]),
                    ), 
                  ),
                ),
                
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: (widget.cities.length / 2).ceil(),
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) => CheckboxListTile(
                      value: selectedCities.contains(widget.cities[(widget.cities.length / 2).toInt() + index]),
                      controlAffinity: ListTileControlAffinity.leading,
                      visualDensity: VisualDensity(vertical: -4),
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        if (value == true) {
                          selectedCities.add(widget.cities[(widget.cities.length / 2).toInt() + index]);
                        } else {
                          selectedCities.remove(widget.cities[(widget.cities.length / 2).toInt() + index]);
                        }
                        setState(() {});
                        widget.onChanged?.call(selectedCategories, selectedCities);
                      },
                      title: Text(widget.cities[(widget.cities.length / 2).toInt() + index]),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}