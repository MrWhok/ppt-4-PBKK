import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';
import { Post } from './entities/post.entity';

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
