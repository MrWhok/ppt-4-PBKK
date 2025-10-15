import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { User } from './entities/user.entity';

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
