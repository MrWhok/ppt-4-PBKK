#import "@preview/upb-cn-templates:0.2.0": upb-cn-report, code

#align(center)[
  #text(1.5em,weight: "bold")[Work Report: [E04] Database Integration]
  #v(1em)
  #text(weight: "bold")[ Pemrograman Berbasis Kerangka Kerja ]
  #v(2em)
  #image("ITS-LOGO-HD.png", width: 10cm)
  #v(2em)
  #text(1.2em)[Disusun Oleh:]
  #v(1em)
  #text(1.2em)[Rafif Aydin Ahmad]
  #text(1em)[(5025231198)]
  #v(6em)
  #text(1.5em, weight: "bold")[Institut Teknologi Sepuluh Nopember]
  #v(1em)
  #text(1.5em, weight: "bold")[2025]
  #v(1em)
]


#pagebreak()

#show: upb-cn-report.with(
  title: "Work Report: [E04] Database Integration",
  author: "Rafif Aydin Ahmad",
  matriculation-number: "5025231198",
  meta: (
    ([Course], [Pemrograman Berbasis Kerangka Kerja]),
    ([Supervisor], [Mr. Moch Nafkhan Alzamzami]),
    ([Project], [[E04] Database Integration]),
  ),
)



#heading(numbering: none)[Abstract]

This report is used to document how to pass the server test. It will include the implementation steps to be taken and the reasons for using them. Also, it contain my opinion on which one is better between TypeORM and Prisma.

= Introduction

== Project Goal
The primary goal of this project is to build a robust RESTful API and integrate it with a real database using two leading Object-Relational Mappers (ORMs). By implementing the same application with both TypeORM and Prisma in a NestJS framework, the project provides a deep, practical understanding of modern database workflows. Key concepts explored include modular architecture, dependency injection, and the significant differences in schema management, type safety, and developer experience between these two popular ORMs.


== Project Scope
The scope of implementation includes:

- Creating a RESTful API using the NestJS framework with dedicated modules for each resource.
- Implementing full CRUD (Create, Read, Update, Delete) operations for three related resources: Users, Posts, and Likes.
- Achieving data persistence by connecting the application to a SQLite database.
- Performing robust server-side input validation using Data Transfer Objects (DTOs) with class-validator decorators and NestJS's built-in ValidationPipe.
- Comparing two distinct database integration approaches:

  1. TypeORM: A flexible, "code-first" ORM using TypeScript decorators and the Repository pattern.
  2. Prisma: A modern, "schema-first" ORM featuring a fully type-safe generated client.









= Design and Implementation

== Project Setup and Analysis
The First step to done this task is to understand the app.e2e-spec test file. This file contains all of the information to pass the test. There are,
  1. Required API Endpoints
    This will tell us exact url paths that needed to be created.
  2. HTTP Methods
    This will tell us the specific HTTP method to be used for each endpoint.
  3. Data Shape (DTOs)
    This will tell us the exact structure of JSON body required for POST and PATCH request.
  4. Expected Responses
    This will tell us specific status code and response body returned for each request.


== Defining the Data Shape and schemas (DTOs and Schemas)
=== Prisma Schemas
Prisma Schemas is define the database structure in the prisma implementation.
1. User Model
```prisma
model User {
  // TODO: Implement
  id    Int     @id @default(autoincrement())
  email String  @unique
  name  String?
  posts Post[]
  likes Like[]

  @@map("users")
}
```
2. Post model
```prisma
model Post {
  // TODO: Implement
  id        Int     @id @default(autoincrement())
  title     String
  content   String?
  author    User    @relation(fields: [authorId], references: [id], onDelete: Cascade)
  authorId  Int
  likes     Like[]

  @@map("posts")
}
```
3. Like Model
```prisma
model Like {
  // TODO: Implement
  id     Int  @id @default(autoincrement())
  user   User @relation(fields: [userId], references: [id], onDelete: Cascade)
  userId Int
  post   Post @relation(fields: [postId], references: [id], onDelete: Cascade)
  postId Int

  @@map("likes")
}
```
=== TypeORM Entities
Entities are special class that map directly to the databases tables. (@) Symbol represents decorators. There are several decorators.

1. user.entity.ts
  ```ts
  @Entity('users')
  export class User {
    // TODO: Implement user entity fields and relationships
    @PrimaryGeneratedColumn()
    id: number;
  
    @Column({ unique: true })
    email: string;
  
    @Column({ nullable: true })
    name: string;
  
    @OneToMany(() => Post, (post) => post.author)
    posts: Post[];
  
    @OneToMany(() => Like, (like) => like.user)
    likes: Like[];
  }
  ```
2. post.entity.ts
  ```ts
  @Entity('posts')
  export class Post {
    // TODO: Implement post entity fields and relationships
    @PrimaryGeneratedColumn()
    id: number;
  
    @Column()
    title: string;
  
    @Column({ type: 'text', nullable: true })
    content: string;
  
    @ManyToOne(() => User, (user) => user.posts, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'authorId' })
    author: User;
  
    @OneToMany(() => Like, (like) => like.post)
    likes: Like[];
  }
  ```
3. like.entity.ts
  ```ts
  @Entity('likes')
  export class Like {
    // TODO: Implement like entity fields and relationships
    @PrimaryGeneratedColumn()
    id: number;
  
    @ManyToOne(() => User, (user) => user.likes, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'userId' }) 
    user: User;
  
    @ManyToOne(() => Post, (post) => post.likes, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'postId' }) 
    post: Post;
  }
  ```
==== Core Decorators
  1. (@)Entity: 
    This decorator marks a class as a database table model.
  2. (@)PrimaryGeneratedColumn():
    This marks a property as the table's primary key.
  3. (@)Column():
    It maps a class property directly to a table column.
  4. (@)JoinColumn():
    It specifies which side of a relationship is the "owner" and will contain the foreign key.
==== Relationship Decorators
  1. (@)ManyToOne():
    This defines the "many-to-one" side of a relationship.
  2. (@)OneToMany():
    This defines the "one-to-many" side.

=== Data Transfer Objects (DTOs)
DTOs is validator of request body. It validates the request body structure, such as the data type, optional or not, empty or not.
1. create-user.dto 
  ```ts
  export class CreateUserDto {
    // TODO: Implement user DTO with validation decorators
    @IsEmail()
    @IsNotEmpty()
    email: string;
  
    @IsString()
    @IsOptional()
    name?: string;
  }
  ```
2. create-post.dto
  ```ts
  export class CreatePostDto {
    // TODO: Implement post DTO with validation decorators
    @IsString()
    @IsNotEmpty()
    title: string;
  
    @IsString()
    @IsOptional()
    content?: string;
  
    @IsInt()
    @IsNotEmpty()
    authorId: number;
  }
  ```
3. create-like.dto
  ```ts
  export class CreateLikeDto {
    // TODO: Implement like DTO with validation decorators
      @IsNumber()
      @IsNotEmpty()
      userId: number;
  
      @IsNumber()
      @IsNotEmpty()
      postId: number;
  }
  ```

== Service Implementation
=== TypeORM Implementation
To implement service using typeORM, we should implement entities first like in the 2.2.2. Then we inject specific repository with specific model. This means UsersService gets a UserRepository, PostsService gets a PostRepository, LikesService gets a LikesRepository. After that, we implemented the CRUD.

1. UserService
  ```ts
  @Injectable()
  export class UsersService {
    constructor(
      @InjectRepository(User)
      private readonly userRepository: Repository<User>,
    ) {}
  
    async create(createUserDto: CreateUserDto): Promise<User> {
      // TODO: Implement user creation
      const user = this.userRepository.create(createUserDto);
      return this.userRepository.save(user);
  
    }
  
    async findAll(): Promise<User[]> {
      // TODO: Implement find all users
      return this.userRepository.find();
    }
  
    async findOne(id: number): Promise<User> {
      // TODO: Implement find user by id
      const user = await this.userRepository.findOne({ where: { id } });
      if (!user) {
        throw new NotFoundException(`User with ID #${id} not found`);
      }
      return user;
  
    }
  
    async update(id: number, updateUserDto: UpdateUserDto): Promise<User> {
      // TODO: Implement user update
      const user = await this.userRepository.preload({
        id,
        ...updateUserDto,
      });
      if (!user) {
        throw new NotFoundException(`User with ID #${id} not found`);
      }
      return this.userRepository.save(user);
  
    }
  
    async remove(id: number): Promise<void> {
      // TODO: Implement user removal
      const result = await this.userRepository.delete(id);
      if (result.affected === 0) {
        throw new NotFoundException(`User with ID #${id} not found`);
      }
    }
  }
  ```
2. PostService
  ```ts
  @Injectable()
  export class PostsService {
    constructor(
      @InjectRepository(Post)
      private readonly postRepository: Repository<Post>,
    ) {}
  
    async create(createPostDto: CreatePostDto): Promise<Post> {
      // TODO: Implement post creation
      const post = this.postRepository.create({
        ...createPostDto,
      });
      return this.postRepository.save(post);
    }
  
    async findAll(): Promise<Post[]> {
      // TODO: Implement find all posts
      return this.postRepository.find({ relations: ['author'] });
    }
  
    async findOne(id: number): Promise<Post> {
      // TODO: Implement find post by id
      const post = await this.postRepository.findOne({
        where: { id },
        relations: ['author'],
      });
      if (!post) {
        throw new NotFoundException(`Post with ID #${id} not found`);
      }
      return post;
  
    }
  
    async update(id: number, updatePostDto: UpdatePostDto): Promise<Post> {
      // TODO: Implement post update
      const { authorId, ...rest } = updatePostDto;
      const post = await this.postRepository.preload({
        id,
        ...rest,
        ...(authorId && { author: { id: authorId } }),
      });
      if (!post) {
        throw new NotFoundException(`Post with ID #${id} not found`);
      }
      return this.postRepository.save(post);
    }
  
    async remove(id: number): Promise<void> {
      // TODO: Implement post removal
      const result = await this.postRepository.delete(id);
      if (result.affected === 0) {
        throw new NotFoundException(`Post with ID #${id} not found`);
      }
  
    }
  }
  ```
3. LikesService
  ```ts
  @Injectable()
  export class LikesService {
    constructor(
      @InjectRepository(Like)
      private readonly likeRepository: Repository<Like>,
    ) {}
  
    async create(createLikeDto: CreateLikeDto): Promise<Like> {
      // TODO: Implement like creation
      const { userId, postId } = createLikeDto;
  
      // TypeORM can create associations using just the foreign key ID.
      const newLike = this.likeRepository.create({
        user: { id: userId },
        post: { id: postId },
      });
  
      return this.likeRepository.save(newLike);
  
    }
  
    async findAll(): Promise<Like[]> {
      // TODO: Implement find all likes
      return this.likeRepository.find({
        relations: ['user', 'post'],
      });
  
    }
  
    async findOne(id: number): Promise<Like> {
      // TODO: Implement find like by id
      const like = await this.likeRepository.findOne({
        where: { id },
        relations: ['user', 'post'],
      });
  
      if (!like) {
        throw new NotFoundException(`Like with ID #${id} not found`);
      }
      return like;
  
    }
  
    async update(id: number, updateLikeDto: UpdateLikeDto): Promise<Like> {
      // TODO: Implement like update
      const like = await this.likeRepository.preload({
        id,
        ...(updateLikeDto.userId && { user: { id: updateLikeDto.userId } }),
        ...(updateLikeDto.postId && { post: { id: updateLikeDto.postId } }),
      });
  
      if (!like) {
        throw new NotFoundException(`Like with ID #${id} not found`);
      }
  
      return this.likeRepository.save(like);
  
    }
  
    async remove(id: number): Promise<void> {
      // TODO: Implement like removal
      const result = await this.likeRepository.delete(id);
  
      if (result.affected === 0) {
        throw new NotFoundException(`Like with ID #${id} not found`);
      }
  
    }
  }
  ```
=== Prisma Implementation
Unlike in the TypeORM, in Prisma, we doesnt need to make entity for each method. By using one file (schema.prisma), we organize all of them in there. Then we connect prisma and typescript using this command.
```bash
pnpm exec prisma generate
```
Then, instead injecting each service with specific repository, in here we inject using prisma service for all services. After that, we implemented the CRUD.
1. UserService
```ts
@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createUserDto: CreateUserDto) {
    // TODO: Implement user creation with Prisma
    return this.prisma.user.create({
      data: createUserDto, 
    });
  }

  async findAll() {
    // TODO: Implement find all users with Prisma
    return this.prisma.user.findMany();

  }

  async findOne(id: number) {
    // TODO: Implement find user by id with Prisma
    const user = await this.prisma.user.findUnique({
      where: { id },
    });

    if (!user) {
      throw new NotFoundException(`User with ID #${id} not found`);
    }

    return user;

  }

  async update(id: number, updateUserDto: UpdateUserDto) {
    // TODO: Implement user update with Prisma
    try {
      return await this.prisma.user.update({
        where: { id },
        data: updateUserDto,
      });
    } catch (error) {
      if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2025') {
        throw new NotFoundException(`User with ID #${id} not found`);
      }
      throw error;
    }

  }

  async remove(id: number) {
    // TODO: Implement user removal with Prisma
    try {
      return await this.prisma.user.delete({
        where: { id },
      });
    } catch (error) {
      if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2025') {
        throw new NotFoundException(`User with ID #${id} not found`);
      }
      throw error;
    }
  }
}
```
2. PostService
```ts
@Injectable()
export class PostsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createPostDto: CreatePostDto) {
    // TODO: Implement post creation with Prisma
    return this.prisma.post.create({ data: createPostDto });
  }

  async findAll() {
    // TODO: Implement find all posts with Prisma
    return this.prisma.post.findMany({ include: { author: true } });
  }

  async findOne(id: number) {
    // TODO: Implement find post by id with Prisma
    const post = await this.prisma.post.findUnique({
      where: { id },
      include: { author: true },
    });
    if (!post) {
      throw new NotFoundException(`Post with ID #${id} not found`);
    }
    return post;

  }

  async update(id: number, updatePostDto: UpdatePostDto) {
    // TODO: Implement post update with Prisma
    try {
      return await this.prisma.post.update({
        where: { id },
        data: updatePostDto,
      });
    } catch (error) {
      if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2025') {
        throw new NotFoundException(`Post with ID #${id} not found`);
      }
      throw error;
    }

  }

  async remove(id: number) {
    // TODO: Implement post removal with Prisma
    try {
      return await this.prisma.post.delete({ where: { id } });
    } catch (error) {
      if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2025') {
        throw new NotFoundException(`Post with ID #${id} not found`);
      }
      throw error;
    }

  }
}
```
3. LikesService
```ts
@Injectable()
export class LikesService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createLikeDto: CreateLikeDto) {
    // TODO: Implement like creation with Prisma
    const { userId, postId } = createLikeDto;
    // Use Prisma to create a like with userId and postId.
    return this.prisma.like.create({
      data: {
        userId,
        postId,
      },
    });
  }

  async findAll() {
    // TODO: Implement find all likes with Prisma
    return this.prisma.like.findMany({
      include: {
        user: true,
        post: true,
      },
    });
  }

  async findOne(id: number) {
    // TODO: Implement find like by id with Prisma
    const like = await this.prisma.like.findUnique({
      where: { id },
      include: {
        user: true,
        post: true,
      },
    });
    if (!like) {
      throw new NotFoundException(`Like with ID #${id} not found`);
    }
    return like;
  }

  async update(id: number, updateLikeDto: UpdateLikeDto) {
    // TODO: Implement like update with Prisma
    try {
      const updatedLike = await this.prisma.like.update({
        where: { id },
        data: {
          ...(updateLikeDto.userId !== undefined && { userId: updateLikeDto.userId }),
          ...(updateLikeDto.postId !== undefined && { postId: updateLikeDto.postId }),
        },
        include: {
          user: true,
          post: true,
        },
      });
      return updatedLike;
    } catch (error) {
      throw new NotFoundException(`Like with ID #${id} not found`);
    }
  }

  async remove(id: number) {
    // TODO: Implement like removal with Prisma
    try {
      return await this.prisma.like.delete({
        where: { id },
      });
    } catch (error) {
      throw new NotFoundException(`Like with ID #${id} not found`);
    }
  }
}
```
= Test Result
To check if our code working correctly, we will test it. To run test we can use this command.
```commands-builtin-shell-bash
pnpm test:e2e
```

In the image below it can be seen that it passes all tests.
#image("Screenshot 2025-09-22 144819.png")

= The Comparison between TypeORM and Prisma

In my opinion, Prisma is better. By using Prisma, we dont need to make separate entities for each method. We only need one central file. It will make easier to organize the data. 
