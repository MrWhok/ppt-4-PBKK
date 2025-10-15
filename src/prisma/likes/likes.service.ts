import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma.service';
import { CreateLikeDto } from './dto/create-like.dto';
import { UpdateLikeDto } from './dto/update-like.dto';

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
