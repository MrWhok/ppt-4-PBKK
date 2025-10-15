import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateLikeDto } from './dto/create-like.dto';
import { UpdateLikeDto } from './dto/update-like.dto';
import { Like } from './entities/like.entity';

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
