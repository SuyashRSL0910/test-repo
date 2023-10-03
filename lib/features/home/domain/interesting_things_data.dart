class InterestingThingsData {

  var title;
  var description;
  var imageUrl;
  var docLinks;
  var videoLinks;
  var otherLinks;

  InterestingThingsData(this.title, this.description, this.imageUrl, this.docLinks, this.videoLinks, this.otherLinks);

  InterestingThingsData.from(Map<dynamic, dynamic> data) {
    title = data['title'];
    description = data['description'];
    imageUrl = data['coverImageLink'];
    docLinks = data['docLinks'];
    videoLinks = data['videoLinks'];
    otherLinks = data['otherLinks'];
  }
}
