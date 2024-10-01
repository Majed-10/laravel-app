#u can use Version
FROM php:8.0-apache

# Set the working directory inside the container
WORKDIR /var/www/html

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl

RUN a2enmod rewrite

# Install Composer globally
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy the current directory contents into the container
COPY . /var/www/html

# Give permissions to Apache to access the app files
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage

# Change Apache to listen on port 0000
RUN sed -i 's/80/0000/g' /etc/apache2/ports.conf \
    && sed -i 's/:80/:0000/g' /etc/apache2/sites-available/000-default.conf

# Expose port 0000
EXPOSE 0000

# Start Apache
CMD ["apache2-foreground"]