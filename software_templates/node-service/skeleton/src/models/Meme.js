class Meme {
  constructor(id, name, description, category, rating, views, maxShares) {
    this.id = id;
    this.name = name;
    this.description = description;
    this.category = category;
    this.rating = rating; // Rating from 0 to 10
    this.views = views;
    this.maxShares = maxShares;
    this.createdAt = new Date();
    this.updatedAt = new Date();
  }

  static fromRequest(data) {
    return new Meme(
      null, // ID will be assigned by the repository
      data.name,
      data.description,
      data.category,
      data.rating,
      data.views,
      data.maxShares
    );
  }

  updateFromRequest(data) {
    this.name = data.name;
    this.description = data.description;
    this.category = data.category;
    this.rating = data.rating;
    this.views = data.views;
    this.maxShares = data.maxShares;
    this.updatedAt = new Date();
  }

  static validateCreateRequest(data) {
    const errors = [];

    if (!data.name || data.name.trim().length === 0) {
      errors.push('Name is required');
    }

    if (!data.category || data.category.trim().length === 0) {
      errors.push('Category is required');
    }

    if (typeof data.rating !== 'number' || data.rating < 0 || data.rating > 10) {
      errors.push('Rating must be a number between 0 and 10');
    }

    if (typeof data.views !== 'number' || data.views < 0) {
      errors.push('Views must be a non-negative number');
    }

    if (typeof data.maxShares !== 'number' || data.maxShares < 0) {
      errors.push('MaxShares must be a non-negative number');
    }

    return errors;
  }
}

module.exports = Meme;