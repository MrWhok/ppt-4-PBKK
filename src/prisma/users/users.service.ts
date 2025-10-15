import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { Prisma } from '@prisma/client'; 


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
