create database shelf;

use shelf;

-- Accounts and authentication

create table accounts (
    account_id bigint unsigned not null auto_increment primary key,
    username varchar(255) not null unique check (char_length(username) >= 3),
    login_hash char(64) not null unique,
    created_at timestamp not null default current_timestamp,
    updated_at timestamp not null default current_timestamp on update current_timestamp
);

create table profile_settings (
    account_id bigint unsigned not null primary key,
    display_name varchar(255) not null,
    visibility enum('public', 'private') not null default 'public',
    updated_at timestamp not null default current_timestamp on update current_timestamp,

    foreign key (account_id) references accounts(account_id) on delete cascade
);

create table sessions_settings (
    account_id bigint unsigned not null primary key,
    session_timeout int not null default 3600 comment 'in minutes',
    logout_policy enum('immediate', 'delayed', 'never') not null default 'delayed',
    updated_at timestamp not null default current_timestamp on update current_timestamp,

    foreign key (account_id) references accounts(account_id) on delete cascade
);

create table sessions (
    session_id char(64) not null primary key,
    account_id bigint unsigned not null,
    created_at timestamp not null default current_timestamp,
    last_used_at timestamp not null default current_timestamp on update current_timestamp,

    foreign key (account_id) references accounts(account_id) on delete cascade
);

-- Saves

create table books (
    book_id bigint unsigned not null auto_increment primary key,
    isbn varchar(13) not null unique,
    title varchar(255) not null,
    author varchar(255),
    page_count int,
    cover_image_url varchar(255),
    created_at timestamp not null default current_timestamp,
    updated_at timestamp not null default current_timestamp on update current_timestamp,
);

create table user_books (
    account_id bigint unsigned not null,
    book_id bigint unsigned not null,
    status enum('read', 'reading', 're-reading', 'want_to_read', 'abandoned') not null default 'want_to_read',
    rating int check (rating >= 1 and rating <= 5),
    current_page int unsigned check (current_page >= 0),
    notes text,
    started_at timestamp,
    finished_at timestamp,
    created_at timestamp not null default current_timestamp,
    updated_at timestamp not null default current_timestamp on update current_timestamp,

    primary key (account_id, book_id),
    foreign key (account_id) references accounts(account_id) on delete cascade,
    foreign key (book_id) references books(book_id) on delete cascade
);