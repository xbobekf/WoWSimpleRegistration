# Use the official PHP image as base
FROM php:7.4-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev

# Enable necessary PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo_mysql zip

# Set the working directory in the container
WORKDIR /var/www/html

# Clone the repository into the container
RUN git clone https://github.com/xbobekf/WoWSimpleRegistration .

# Copy the configuration file
COPY config.php config.php

# Set permissions for Apache
RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite

# Expose port 80 to the outside world
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]