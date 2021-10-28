import 'package:flutter/material.dart';
import 'package:tukangku/models/category_service_model.dart';
import 'package:tukangku/models/filter_service_model.dart';
import 'package:tukangku/repositories/category_service_repository.dart';
import 'package:tukangku/screens/service/services.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  CategoryServiceRepository _categoryServiceRepo = CategoryServiceRepository();
  TextEditingController searchController = TextEditingController();

  List<CategoryServiceModel>? listCategoryService;

  Future getCategoryService() async {
    listCategoryService = await _categoryServiceRepo.getCategoryServices();
    setState(() {});
  }

  @override
  void initState() {
    getCategoryService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 25,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.black87,
          icon: Icon(Icons.arrow_back),
        ),
        title: Container(
            height: 40,
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  textAlignVertical: TextAlignVertical.bottom,
                  maxLines: 1,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    FilterServiceModel filterServiceModel =
                        FilterServiceModel(q: value);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Services(filterService: filterServiceModel);
                    }));
                  },
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.only(left: 10, top: 6, bottom: 11),
                      hintText: 'Cari layanan disini...',
                      hintStyle:
                          TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                        size: 25,
                        color: Colors.grey,
                      )),
                ),
              ),
            ])),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            listCategoryService != null
                ? Container(
                    color: Colors.white,
                    width: size.width,
                    padding: EdgeInsets.all(15),
                    child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              FilterServiceModel filterServiceModel =
                                  FilterServiceModel(
                                      categoryService:
                                          listCategoryService![index]);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Services(
                                    filterService: filterServiceModel);
                              }));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(listCategoryService![index].name!),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            // height: 3,
                            thickness: 0.5,
                          );
                        },
                        itemCount: listCategoryService!.length),
                  )
                : Center(
                    child: Container(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
