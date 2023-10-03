class NewsLetterData {

  var title;
  var description;
  var published_date;
  var author;
  var newsletter_link;

  NewsLetterData(this.title, this.description, this.published_date, this.author, this.newsletter_link);

  NewsLetterData.from(Map<dynamic, dynamic> data) {
    title = data['title'];
    description = data['description'];
    published_date = data['date'];
    author = data['author'];
    newsletter_link = data['link'];
  }
}
