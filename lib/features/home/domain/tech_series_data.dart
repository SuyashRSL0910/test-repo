class TechSeriesData {

  var title;
  var description;
  var imageUrl;
  var docLinks;
  var videoLinks;
  var otherLinks;

  TechSeriesData(this.title, this.description, this.imageUrl, this.docLinks, this.videoLinks, this.otherLinks);

  TechSeriesData.from(Map<dynamic, dynamic> data) {
    title = data['title'];
    description = data['description'];
    imageUrl = data['coverImageLink'];
    docLinks = data['docLinks'];
    videoLinks = data['videoLinks'];
    otherLinks = data['otherLinks'];
  }
}
