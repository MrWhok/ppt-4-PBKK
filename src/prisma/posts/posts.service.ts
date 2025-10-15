import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma.service';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';
import { Prisma } from '@prisma/client';

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
