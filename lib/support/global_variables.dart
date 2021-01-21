import 'package:project1/model/user_model.dart';

Person userGlobal;

const stringAnimesAiring = "Top Airing";
const stringAnimesHighest = "Highest Rated";
const stringAnimesPopular = "Most Popular";
const stringAnimesUpcoming = "Top Upcoming";

const stringTabSearchAnimes = "Anime";
const stringTabSearchCharacters = "Character";
const stringTabSearchCategories = "Categorie";

double mainAxisSpacing = 10.0;
double crossAxisSpacing = 5.0;
double childAspectRatio = 0.55;
int crossAxisCount = 2;

void setUser(Person user) {
  userGlobal = user;
}
