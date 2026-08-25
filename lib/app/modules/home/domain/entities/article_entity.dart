// create Article entity
import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String? uri;
  final String? url;
  final int? id;
  final int? assetId;
  final String? source;
  final DateTime? publishedDate;
  final DateTime? updated;
  final String? section;
  final String? subsection;
  final String? nytdsection;
  final String? adxKeywords;
  final dynamic column;
  final String? byline;
  final String? type;
  final String? title;
  final String? articleModelAbstract;
  final List<String>? desFacet;
  final List<String>? orgFacet;
  final List<dynamic>? perFacet;
  final List<String>? geoFacet;
  final List<Media>? media;
  final int? etaId;
  const Article({
    this.uri,
    this.url,
    this.id,
    this.assetId,
    this.source,
    this.publishedDate,
    this.updated,
    this.section,
    this.subsection,
    this.nytdsection,
    this.adxKeywords,
    this.column,
    this.byline,
    this.type,
    this.title,
    this.articleModelAbstract,
    this.desFacet,
    this.orgFacet,
    this.perFacet,
    this.geoFacet,
    this.media,
    this.etaId,
  });

  factory Article.fromEntity(Article entity) {
    return Article(
      uri: entity.uri,
      url: entity.url,
      id: entity.id,
      assetId: entity.assetId,
      source: entity.source,
      publishedDate: entity.publishedDate,
      updated: entity.updated,
      section: entity.section,
      subsection: entity.subsection,
      nytdsection: entity.nytdsection,
      adxKeywords: entity.adxKeywords,
      column: entity.column,
      byline: entity.byline,
      type: entity.type,
      title: entity.title,
      articleModelAbstract: entity.articleModelAbstract,
      desFacet: entity.desFacet,
      orgFacet: entity.orgFacet,
      perFacet: entity.perFacet,
      geoFacet: entity.geoFacet,
      media: entity.media,
      etaId: entity.etaId,
    );
  }

  Article toEntity() {
    return Article(
      uri: uri,
      url: url,
      id: id,
      assetId: assetId,
      source: source,
      publishedDate: publishedDate,
      updated: updated,
      section: section,
      subsection: subsection,
      nytdsection: nytdsection,
      adxKeywords: adxKeywords,
      column: column,
      byline: byline,
      type: type,
      title: title,
      articleModelAbstract: articleModelAbstract,
      desFacet: desFacet,
      orgFacet: orgFacet,
      perFacet: perFacet,
      geoFacet: geoFacet,
      media: media,
      etaId: etaId,
    );
  }

  @override
  List<Object?> get props => [
        uri,
        url,
        id,
        assetId,
        source,
        publishedDate,
        updated,
        section,
        subsection,
        nytdsection,
        adxKeywords,
        column,
        byline,
        type,
        title,
        articleModelAbstract,
        desFacet,
        orgFacet,
        perFacet,
        geoFacet,
        media,
        etaId,
      ];
}

class Media extends Equatable {
  final String? type;
  final String? subtype;
  final String? caption;
  final String? copyright;
  final int? approvedForSyndication;
  final List<MediaMetadatum>? mediaMetadata;

  const Media({
    this.type,
    this.subtype,
    this.caption,
    this.copyright,
    this.approvedForSyndication,
    this.mediaMetadata,
  });

  factory Media.fromEntity(Map<String, dynamic> json) => Media(
        type: json["type"],
        subtype: json["subtype"],
        caption: json["caption"],
        copyright: json["copyright"],
        approvedForSyndication: json["approved_for_syndication"],
        mediaMetadata: json["media-metadata"] == null
            ? []
            : List<MediaMetadatum>.from(
                json["media-metadata"]!.map((x) => MediaMetadatum.fromJson(x))),
      );

  Map<String, dynamic> toEntity() => {
        "type": type,
        "subtype": subtype,
        "caption": caption,
        "copyright": copyright,
        "approved_for_syndication": approvedForSyndication,
        "media-metadata": mediaMetadata == null
            ? []
            : List<dynamic>.from(mediaMetadata!.map((x) => x.toEntity())),
      };

  @override
  List<Object?> get props => [
        type,
        subtype,
        caption,
        copyright,
        approvedForSyndication,
        mediaMetadata
      ];
}

class MediaMetadatum extends Equatable {
  final String? url;
  final String? format;
  final int? height;
  final int? width;

  const MediaMetadatum({
    this.url,
    this.format,
    this.height,
    this.width,
  });

  factory MediaMetadatum.fromJson(Map<String, dynamic> json) => MediaMetadatum(
        url: json["url"],
        format: json["format"],
        height: json["height"],
        width: json["width"],
      );

  Map<String, dynamic> toEntity() => {
        "url": url,
        "format": format,
        "height": height,
        "width": width,
      };

  @override
  List<Object?> get props => [url, format, height, width];
}
